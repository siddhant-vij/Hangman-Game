import 'dart:math';

import 'package:flutter/services.dart' show rootBundle;

import 'package:hangman_game/utils/constants.dart';

class WordService {
  late List<String> easyWords;
  late List<String> mediumWords;
  late List<String> hardWords;

  Future<void> initialize(String wordsFilePath) async {
    easyWords = await _loadWords(wordsFilePath, minLengthEasy, maxLengthEasy);
    mediumWords = await _loadWords(wordsFilePath, minLengthMedium, maxLengthMedium);
    hardWords = await _loadWords(wordsFilePath, minLengthHard);
  }

  Future<List<String>> _loadWords(String wordsFilePath, int minLength,
    [int maxLength = -1]) async {
  final fileString = await rootBundle.loadString(wordsFilePath);
  final lines = fileString.split('\n');
  return lines.where((word) {
    final trimmedWord = word.trim(); // Trim the word to remove hidden characters like '\r'
    final length = trimmedWord.length;
    return maxLength == -1
        ? length >= minLength
        : length >= minLength && length <= maxLength;
  }).map((word) => word.trim()).toList(); // Trim each word again to be sure
}


  Future<String> getRandomWord(Enum difficulty) async {
    final random = Random();
    List<String> words = [];
    switch (difficulty) {
      case Difficulty.easy:
        words = easyWords;
        break;
      case Difficulty.medium:
        words = mediumWords;
        break;
      case Difficulty.hard:
        words = hardWords;
        break;
    }
    final index = random.nextInt(words.length);
    return words[index].substring(0, words[index].length - 1);
  }
}
