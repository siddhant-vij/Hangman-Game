import 'dart:io';

import 'package:hangman_game/models/score.dart';
import 'package:hangman_game/utils/constants.dart';

class ScoreService {
  final String scoreFilePath;
  final List<Score> _scores;

  ScoreService(this.scoreFilePath) : _scores = [];

  Future<void> _ensureFileExists() async {
    final file = File(scoreFilePath);
    if (!file.existsSync()) {
      await file.create();
      await file.writeAsString('Date, Time (min.)\n');
    }
  }

  Future<void> saveScores() async {
    await _ensureFileExists();
    final lines = await File(scoreFilePath).readAsLines();
    final buffer = StringBuffer();
    buffer.writeln(lines[0]);

    _scores.sort((a, b) => a.time.compareTo(b.time));

    for (final score in _scores.take(numberOfScoresToSave)) {
      buffer.writeln('${score.date},${score.time}');
    }
    await File(scoreFilePath).writeAsString(buffer.toString());
  }

  Future<List<Score>> loadScores() async {
    await _ensureFileExists();
    final lines = await File(scoreFilePath).readAsLines();
    _scores.clear();
    for (final line in lines.skip(1)) {
      final values = line.split(',');
      _scores.add(Score(
        date: values[0],
        time: values[1],
      ));
    }
    return _scores;
  }
}
