import 'word.dart';

class Game {
  Word word;
  int incorrectGuesses;
  bool hintUsed;

  Game(this.word)
      : incorrectGuesses = 0,
        hintUsed = false;

  bool isGameOver() {
    return word.isFullyRevealed() || incorrectGuesses >= 6;
  }

  bool hasPlayerWon() {
    return word.isFullyRevealed();
  }
}
