import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hangman_game/screens/difficulty_screen.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'package:hangman_game/models/game.dart';
import 'package:hangman_game/models/word.dart';
import 'package:hangman_game/services/game_service.dart';
import 'package:hangman_game/utils/constants.dart';

class GameScreen extends StatefulWidget {
  final Word wordToBeGuessed;
  final Game game;

  const GameScreen({
    super.key,
    required this.wordToBeGuessed,
    required this.game,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int _elapsedTime = 0;
  late Timer _timer;
  final gameService = GameService();

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

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
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

  void checkEndOfGame() {
    if (widget.game.isGameOver()) {
      _stopTimer();
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
        buttons: [
          DialogButton(
            onPressed: () => {
              Navigator.pop(context),
              resetGame(),
            },
            width: 128,
            child: const Text(
              'Restart',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ).show();
    }
  }

  void resetGame() {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => const DifficultyScreen()),
    (Route<dynamic> route) => false,
  );
}


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: mainBackgroundColor,
        body: SafeArea(
          minimum: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
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
                      child: const Icon(
                        Icons.arrow_back,
                        size: 32.0,
                        color: mainTextColor,
                      ),
                    ),
                    Text(
                      getTimerInFormat(),
                      style: normalTextStyle,
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Icon(
                        Icons.lightbulb,
                        size: 32.0,
                        color: mainTextColor,
                      ),
                    )
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
                flex: 1,
                child: Center(
                  child: Text(
                    widget.game.word.text,
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
              )
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
    final isCorrectGuess =
        guess.toLowerCase() == widget.wordToBeGuessed.text.toLowerCase();
    if (isCorrectGuess) {
      widget.game.word.lettersRevealed = List.generate(
        widget.wordToBeGuessed.text.length - 1,
        (index) => true,
      );
    } else {
      widget.game.incorrectGuesses = 6;
    }
    setState(() {
      tappedLetters[letters.length] = true;
    });
    widget.checkEndOfGameCallback();
    if(mounted) {      
      Navigator.pop(context);
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
                    padding: const EdgeInsets.all(4.0),
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
                  padding: const EdgeInsets.all(4.0),
                  child: createButton(i),
                ),
              ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
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
                                  child: const Text(
                                    "Submit",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                )
                              ]).show();
                        },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    backgroundColor:
                        tappedLetters.last ? Colors.grey : mainButtonColor,
                    minimumSize: const Size(double.infinity, 40),
                  ),
                  child: const Text(
                    'WORD',
                    style: TextStyle(fontSize: 16),
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
    return ElevatedButton(
      onPressed: tappedLetters[index]
          ? null
          : () {
              setState(() {
                tappedLetters[index] = true;
              });
              widget.onLetterPressed(letters[index]);
            },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        backgroundColor: tappedLetters[index] ? Colors.grey : mainButtonColor,
        minimumSize: const Size(double.infinity, 40),
      ),
      child: Text(
        letters[index],
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
