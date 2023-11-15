import 'package:flutter/material.dart';

import 'package:hangman_game/screens/home_screen.dart';
import 'package:hangman_game/utils/constants.dart';
import 'package:hangman_game/utils/size_config.dart';

void main(List<String> args) {
  runApp(const HangmanGame());
}

class HangmanGame extends StatelessWidget {
  const HangmanGame({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return MaterialApp(
      home: Scaffold(
        backgroundColor: mainBackgroundColor,
        body: SafeArea(
          minimum: EdgeInsets.symmetric(
            horizontal: getWidth(24.0),
            vertical: getHeight(48.0),
          ),
          child: const HomeScreen(),
        ),
      ),
    );
  }
}
