class Word {
  String text;
  List<bool> lettersRevealed;

  Word({required this.text})
      : lettersRevealed = List.filled(text.length-1, false);

  bool isFullyRevealed() {
    return !lettersRevealed.contains(false);
  }
}
