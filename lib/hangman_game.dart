import 'package:flutter/material.dart';

import 'package:hangman_game/screens/home_screen.dart';
import 'package:hangman_game/utils/constants.dart';

void main(List<String> args) {
  runApp(const HangmanGame());
}

class HangmanGame extends StatelessWidget {
  const HangmanGame({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        backgroundColor: mainBackgroundColor,
        body: SafeArea(
          minimum: EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
          child: HomeScreen(),
        ),
      ),
    );
  }
}
