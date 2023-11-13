import 'package:flutter/material.dart';

import 'package:hangman_game/utils/constants.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: mainBackgroundColor,
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
