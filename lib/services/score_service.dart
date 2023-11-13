import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'package:hangman_game/models/score.dart';
import 'package:hangman_game/utils/constants.dart';

class ScoreService {
  late File _file;
  final List<Score> _scores;
  final bool isDevelopment;

  ScoreService({this.isDevelopment = true}) : _scores = [];

  Future<File> _getDevFile() async {
    final path = '${Directory.current.path}/data/scores.csv';
    final file = File(path);
    if (!await file.parent.exists()) {
      await file.parent.create(recursive: true);
    }
    return file;
  }

  Future<File> _getProdFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/scores.csv';
    return File(path);
  }

  Future<File> _getFile() {
    if (isDevelopment) {
      return _getDevFile();
    } else {
      return _getProdFile();
    }
  }

  Future<void> _ensureFileExists() async {
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
    await _ensureFileExists();
    final buffer = StringBuffer();
    buffer.writeln('Date, Time');

    _scores.sort((a, b) => a.time.compareTo(b.time));

    for (final score in _scores.take(numberOfScoresToSave)) {
      buffer.writeln('${score.date},${getTimerInFormat(score.time)}');
    }
    await _file.writeAsString(buffer.toString());
  }

  Future<List<Score>> loadScores() async {
    await _ensureFileExists();
    final lines = await _file.readAsLines();
    _scores.clear();
    for (final line in lines.skip(1)) {
      final values = line.split(',');
      _scores.add(Score(
        date: values[0],
        time: getTimerInSeconds(values[1]),
      ));
    }
    return _scores;
  }
}
