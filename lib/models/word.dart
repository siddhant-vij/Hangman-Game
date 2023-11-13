class Word {
  String text;
  List<bool> lettersRevealed;

  Word({required this.text})
      : lettersRevealed = List.filled(text.length, false);

  bool isFullyRevealed() {
    return !lettersRevealed.contains(false);
  }
}
