import 'dart:math';

import 'package:hangman_game/models/game.dart';
import 'package:hangman_game/models/word.dart';

class GameService {
  bool handleGuess(Game game, String guess) {
    bool guessCorrect = false;
    if (!game.word.text.contains(guess.toLowerCase())) {
      game.incorrectGuesses++;
    } else {
      for (int i = 0; i < game.word.text.length; i++) {
        if (game.word.text[i].toLowerCase() == guess.toLowerCase()) {
          if (!game.word.lettersRevealed[i]) {
            guessCorrect = true;
            game.word.lettersRevealed[i] = true;
          }
        }
      }
    }
    return guessCorrect;
  }

  String getRevealedWord(Word word) {
    String revealedWord = '';
    for (int i = 0; i < word.text.length; i++) {
      if (word.lettersRevealed[i]) {
        revealedWord += ' ${word.text[i].toUpperCase()} ';
      } else {
        revealedWord += ' _ ';
      }
    }
    return revealedWord;
  }

  void useHint(Game game) {
    if (!game.hintUsed) {
      final random = Random();
      String letter;
      Set<int> unrevealedIndices = {};

      for (int i = 0; i < game.word.text.length; i++) {
        if (!game.word.lettersRevealed[i]) {
          unrevealedIndices.add(i);
        }
      }

      if (unrevealedIndices.isNotEmpty) {
        int randomIndex = unrevealedIndices
            .elementAt(random.nextInt(unrevealedIndices.length));
        letter = game.word.text[randomIndex].toUpperCase();
        for (int i = 0; i < game.word.text.length; i++) {
          if (game.word.text[i].toUpperCase() == letter) {
            game.word.lettersRevealed[i] = true;
          }
        }
        game.hintUsed = true;
      }
    }
  }
}
