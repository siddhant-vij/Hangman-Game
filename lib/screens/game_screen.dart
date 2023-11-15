import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'package:hangman_game/utils/size_config.dart';
import 'package:hangman_game/screens/difficulty_screen.dart';
import 'package:hangman_game/models/score.dart';
import 'package:hangman_game/services/score_service.dart';
import 'package:hangman_game/models/game.dart';
import 'package:hangman_game/models/word.dart';
import 'package:hangman_game/services/game_service.dart';
import 'package:hangman_game/utils/constants.dart';

class GameScreen extends StatefulWidget {
  final Word wordToBeGuessed;
  final Game game;
  final Difficulty difficulty;

  const GameScreen({
    super.key,
    required this.wordToBeGuessed,
    required this.game,
    required this.difficulty,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int _elapsedTime = 0;
  late Timer _timer;
  final gameService = GameService();
  final scoreService = ScoreService();

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedTime++;
      });
    });
  }

  void _stopTimer() {
    _timer.cancel();
  }

  String getTimerInFormat() {
    final minutes = (_elapsedTime ~/ 60).toString().padLeft(2, '0');
    final seconds = (_elapsedTime % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String buildImage() {
    return 'images/${widget.game.incorrectGuesses}.png';
  }

  void onLetterPressed(String letter) {
    bool correct = gameService.handleGuess(widget.game, letter);
    setState(() {
      if (!correct) {
        buildImage();
      }
      checkEndOfGame();
    });
  }

  void checkEndOfGame() async {
    if (widget.game.isGameOver()) {
      _stopTimer();
      if (mounted) {
        showEndOfGameDialog();
        if (widget.game.hasPlayerWon()) {
          await saveScore();
        }
      }
    }
  }

  Future<void> saveScore() async {
    final scoreService = ScoreService();
    final newScore = Score(
      date: DateFormat('dd-MM-yyyy').format(DateTime.now()),
      time: _elapsedTime,
      difficulty: widget.difficulty,
    );
    await scoreService.addScore(newScore);
  }

  void showEndOfGameDialog() {
    if (!mounted) return;

    final title = widget.game.hasPlayerWon()
        ? 'Congratulations!\n\nWord: ${widget.wordToBeGuessed.text.toUpperCase()}'
        : 'Game Over.\n\nWord: ${widget.wordToBeGuessed.text.toUpperCase()}';
    final desc = widget.game.hasPlayerWon()
        ? 'You won the game. Play again?'
        : 'You lost the game. Try again?';

    Alert(
      context: context,
      type: widget.game.hasPlayerWon() ? AlertType.success : AlertType.error,
      title: title,
      desc: desc,
      closeFunction: () {},
      buttons: [
        DialogButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            resetGame();
          },
          width: getWidth(128.0),
          child: Text(
            'Restart',
            style: TextStyle(
              color: Colors.white,
              fontSize: getHeight(16.0),
            ),
          ),
        ),
      ],
    ).show();
  }

  void resetGame() {
    if (!mounted) return;

    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const DifficultyScreen()),
      (Route<dynamic> route) => false,
    );
  }

  void onHintPressed() {
    if (!widget.game.hintUsed) {
      setState(() {
        gameService.useHint(widget.game);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: mainBackgroundColor,
        body: SafeArea(
          minimum: EdgeInsets.symmetric(
            horizontal: getWidth(24.0),
            vertical: getHeight(24.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back,
                        size: getHeight(32.0),
                        color: mainTextColor,
                      ),
                    ),
                    Text(
                      getTimerInFormat(),
                      style: normalTextStyle,
                    ),
                    TextButton(
                      onPressed: widget.game.hintUsed ? null : onHintPressed,
                      child: Icon(
                        Icons.lightbulb,
                        size: getHeight(32.0),
                        color:
                            widget.game.hintUsed ? Colors.grey : mainTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Center(
                  child: Image.asset(
                    buildImage(),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: SingleLineFittedText(
                    key: ValueKey<String>(
                      gameService.getRevealedWord(
                        widget.game.word,
                      ),
                    ),
                    word: gameService.getRevealedWord(
                      widget.game.word,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: AlphabetKeyPad(
                  game: widget.game,
                  wordToBeGuessed: widget.wordToBeGuessed,
                  onLetterPressed: onLetterPressed,
                  checkEndOfGameCallback: checkEndOfGame,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AlphabetKeyPad extends StatefulWidget {
  final Word wordToBeGuessed;
  final Game game;
  final Function(String letter) onLetterPressed;
  final Function() checkEndOfGameCallback;

  const AlphabetKeyPad({
    super.key,
    required this.wordToBeGuessed,
    required this.game,
    required this.onLetterPressed,
    required this.checkEndOfGameCallback,
  });

  @override
  State<AlphabetKeyPad> createState() => _AlphabetKeyPadState();
}

class _AlphabetKeyPadState extends State<AlphabetKeyPad> {
  final List<String> letters =
      List.generate(26, (index) => String.fromCharCode(index + 65));
  List<bool> tappedLetters = List.generate(27, (index) => false);

  void submitWordGuess(String guess) {
    if (guess.trim().isEmpty) {
      return;
    }
    final isCorrectGuess =
        guess.trim().toLowerCase() == widget.wordToBeGuessed.text.toLowerCase();

    FocusScope.of(context).unfocus();
    Navigator.of(context, rootNavigator: true).pop();

    if (mounted) {
      setState(() {
        if (isCorrectGuess) {
          widget.game.word.lettersRevealed =
              List.filled(widget.game.word.text.length, true);
        } else {
          widget.game.incorrectGuesses = 6;
        }
        tappedLetters.fillRange(0, tappedLetters.length, true);
      });

      Future.delayed(Duration.zero, () {
        if (mounted) {
          widget.checkEndOfGameCallback();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int row = 0; row < 3; row++)
          Row(
            children: [
              for (int i = 0; i < 7; i++)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: getHeight(4.0),
                      horizontal: getWidth(4.0),
                    ),
                    child: createButton(row * 7 + i),
                  ),
                ),
            ],
          ),
        Row(
          children: [
            for (int i = 21; i < 26; i++)
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: getHeight(4.0),
                    horizontal: getWidth(4.0),
                  ),
                  child: createButton(i),
                ),
              ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: getHeight(4.0),
                  horizontal: getWidth(4.0),
                ),
                child: ElevatedButton(
                  onPressed: tappedLetters.last
                      ? null
                      : () {
                          setState(() {
                            tappedLetters[letters.length] = true;
                          });
                          final TextEditingController textFieldController =
                              TextEditingController();
                          Alert(
                              context: context,
                              title: "Enter your guess",
                              closeFunction: () {},
                              content: Column(
                                children: <Widget>[
                                  TextField(
                                    controller: textFieldController,
                                    decoration: const InputDecoration(
                                      icon: Icon(Icons.text_fields),
                                      labelText: 'Word',
                                    ),
                                    autofocus: true,
                                  ),
                                ],
                              ),
                              buttons: [
                                DialogButton(
                                  onPressed: () {
                                    submitWordGuess(textFieldController.text);
                                  },
                                  child: Text(
                                    "Submit",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: getHeight(16.0),
                                    ),
                                  ),
                                )
                              ]).show();
                        },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        getRadius(16.0),
                      ),
                    ),
                    backgroundColor:
                        tappedLetters.last ? Colors.grey : mainButtonColor,
                    minimumSize: Size(
                      double.infinity,
                      getHeight(40.0),
                    ),
                  ),
                  child: Text(
                    'WORD',
                    style: TextStyle(
                      fontSize: getHeight(16.0),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget createButton(int index) {
    bool isLetterRevealed = widget.game.word.text.toUpperCase().split('').any(
        (letter) =>
            letter == letters[index] &&
            widget.game.word.lettersRevealed[
                widget.game.word.text.toUpperCase().indexOf(letter)]);
    return ElevatedButton(
      onPressed: tappedLetters[index] || isLetterRevealed
          ? null
          : () {
              setState(() {
                tappedLetters[index] = true;
              });
              widget.onLetterPressed(letters[index]);
            },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            getRadius(16.0),
          ),
        ),
        backgroundColor: tappedLetters[index] ? Colors.grey : mainButtonColor,
        minimumSize: Size(
          double.infinity,
          getHeight(40.0),
        ),
      ),
      child: Text(
        letters[index],
        style: TextStyle(
          fontSize: getHeight(16.0),
        ),
      ),
    );
  }
}
