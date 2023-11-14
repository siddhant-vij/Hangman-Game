import 'package:flutter/material.dart';

import 'package:hangman_game/screens/loading_screen.dart';
import 'package:hangman_game/screens/score_screen.dart';
import 'package:hangman_game/services/score_service.dart';
import 'package:hangman_game/utils/constants.dart';

import 'difficulty_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ScoreService scoreService;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    scoreService = ScoreService();
    ensureFileExists();
  }

  void ensureFileExists() async {
    await scoreService.ensureFileExists();
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void onButtonPressed() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoadingScreen(),
      ),
    );

    final highScores = await scoreService.loadScores();

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ScoreScreen(highScores: highScores),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Center(
            child: Text(
              'HANGMAN',
              style: headerTextStyle,
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Center(
            child: Image.asset(
              'images/gallow.png',
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Center(
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DifficultyScreen(),
                  ),
                );
              },
              style: buttonStyle,
              child: Text(
                'Start',
                style: buttonTextStyle,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Center(
            child: TextButton(
              onPressed: onButtonPressed,
              style: buttonStyle,
              child: Text(
                'High Scores',
                style: buttonTextStyle,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
