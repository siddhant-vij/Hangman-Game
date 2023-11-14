import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'package:hangman_game/models/score.dart';
import 'package:hangman_game/utils/constants.dart';

class ScoreService {
  final Map<Difficulty, List<Score>> _scoresByDifficulty = {
    Difficulty.easy: [],
    Difficulty.medium: [],
    Difficulty.hard: [],
  };

  ScoreService();

  Future<File> get _file async {
    return await _getFile();
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/scores.csv';
    return File(path);
  }

  Future<void> ensureFileExists() async {
    final file = await _getFile();
    if (!await file.exists()) {
      await file.create(recursive: true);
      await file.writeAsString('Date, Time\n');
    }
  }

  String getTimerInFormat(int time) {
    final minutes = (time ~/ 60).toString().padLeft(2, '0');
    final seconds = (time % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  int getTimerInSeconds(String time) {
    final values = time.split(':');
    return int.parse(values[0]) * 60 + int.parse(values[1]);
  }

  Future<void> saveScores() async {
    await ensureFileExists();
    final file = await _file;
    final buffer = StringBuffer();
    buffer.writeln('Date,Time,Difficulty');

    _scoresByDifficulty.forEach((difficulty, scores) {
      scores.sort((a, b) => a.time.compareTo(b.time));
      scores.take(numberOfScoresToSave).forEach((score) {
        buffer.writeln(
            '${score.date},${getTimerInFormat(score.time)},${score.difficulty.toString().split('.').last}');
      });
    });

    await file.writeAsString(buffer.toString());
  }

  Future<void> addScore(Score score) async {
    await ensureFileExists();
    await loadScores();
    final scores = _scoresByDifficulty[score.difficulty] ?? [];
    scores.add(score);
    scores.sort((a, b) => a.time.compareTo(b.time));
    _scoresByDifficulty[score.difficulty] =
        scores.take(numberOfScoresToSave).toList();
    await saveScores();
  }

  Future<Map<Difficulty, List<Score>>> loadScores() async {
    final file = await _file;
    final lines = await file.readAsLines();
    _scoresByDifficulty.forEach((key, value) => value.clear());

    for (final line in lines.skip(1)) {
      final values = line.split(',');
      if (values.length == 3) {
        final score = Score(
          date: values[0],
          time: getTimerInSeconds(values[1]),
          difficulty: _parseDifficulty(values[2]),
        );
        _scoresByDifficulty[score.difficulty]?.add(score);
      }
    }

    _scoresByDifficulty.forEach((difficulty, scores) {
      scores.sort((a, b) => a.time.compareTo(b.time));
    });

    return _scoresByDifficulty;
  }

  Difficulty _parseDifficulty(String difficultyString) {
    return Difficulty.values.firstWhere(
      (d) => d.toString().split('.').last == difficultyString,
      orElse: () =>
          throw ArgumentError('Invalid difficulty level: $difficultyString'),
    );
  }
}
