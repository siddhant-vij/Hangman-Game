import 'package:hangman_game/utils/constants.dart';

class Score {
  final String date;
  final int time;
  final Difficulty difficulty;

  Score({required this.date, required this.time, required this.difficulty});
}
