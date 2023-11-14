import 'package:flutter/material.dart';

import 'package:hangman_game/models/game.dart';
import 'package:hangman_game/models/word.dart';
import 'package:hangman_game/screens/game_screen.dart';
import 'package:hangman_game/screens/loading_screen.dart';
import 'package:hangman_game/services/word_service.dart';
import 'package:hangman_game/utils/constants.dart';

class DifficultyScreen extends StatefulWidget {
  const DifficultyScreen({super.key});

  @override
  State<DifficultyScreen> createState() => _DifficultyScreenState();
}

class _DifficultyScreenState extends State<DifficultyScreen> {
  late WordService wordService;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    wordService = WordService();
    loadWords();
  }

  void loadWords() async {
    await wordService.initialize(wordsFilePath);
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void onButtonPressed(Difficulty difficulty) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoadingScreen(),
      ),
    );

    final word = await wordService.getRandomWord(difficulty);
    final wordToBeGuessed = Word(text: word);
    final game = Game(wordToBeGuessed);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => GameScreen(
            wordToBeGuessed: wordToBeGuessed,
            game: game,
            difficulty: difficulty,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: mainBackgroundColor,
        body: SafeArea(
          minimum:
              const EdgeInsets.symmetric(horizontal: 24.0, vertical: 184.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Center(
                  child: TextButton(
                    onPressed: () => onButtonPressed(Difficulty.easy),
                    style: buttonStyle,
                    child: Text(
                      'Easy',
                      style: buttonTextStyle,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: TextButton(
                    onPressed: () => onButtonPressed(Difficulty.medium),
                    style: buttonStyle,
                    child: Text(
                      'Medium',
                      style: buttonTextStyle,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: TextButton(
                    onPressed: () => onButtonPressed(Difficulty.hard),
                    style: buttonStyle,
                    child: Text(
                      'Hard',
                      style: buttonTextStyle,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
