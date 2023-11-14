import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const wordsFilePath = 'assets/dictionary.txt';

const numberOfScoresToSave = 5;
const minLengthEasy = 3;
const maxLengthEasy = 6;
const minLengthMedium = 7;
const maxLengthMedium = 10;
const minLengthHard = 11;

enum Difficulty {
  easy,
  medium,
  hard,
}

const mainBackgroundColor = Color(0xFF421b9b);
const mainButtonColor = Color(0xFF007AE2);
const mainTextColor = Color(0xFFFFFFFF);

final headerTextStyle = GoogleFonts.patrickHand(
  fontSize: 56.0,
  fontWeight: FontWeight.bold,
  color: mainTextColor,
  letterSpacing: 1.5,
  wordSpacing: 1.5,
);

final normalTextStyle = GoogleFonts.patrickHand(
  fontSize: 32.0,
  fontWeight: FontWeight.bold,
  color: mainTextColor,
  letterSpacing: 1.5,
  wordSpacing: 1.5,
);

final smallHeaderStyle = GoogleFonts.patrickHand(
  fontSize: 24.0,
  fontWeight: FontWeight.bold,
  color: mainTextColor,
  letterSpacing: 1.5,
  wordSpacing: 1.5,
);

final smallTextStyle = GoogleFonts.patrickHand(
  fontSize: 16.0,
  fontWeight: FontWeight.bold,
  color: mainTextColor,
  letterSpacing: 1.5,
  wordSpacing: 1.5,
);

final buttonTextStyle = GoogleFonts.patrickHand(
  fontSize: 24.0,
  fontWeight: FontWeight.bold,
  color: mainTextColor,
  letterSpacing: 1,
  wordSpacing: 1.25,
);

final buttonStyle = ElevatedButton.styleFrom(
  backgroundColor: mainButtonColor,
  fixedSize: const Size(192.0, 56.0),
  elevation: 6.0,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8.0),
  ),
);

class SingleLineFittedText extends StatelessWidget {
  final String word;

  const SingleLineFittedText({Key? key, required this.word}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final textPainter = TextPainter(
          text: TextSpan(text: word, style: const TextStyle(fontSize: 40.0)),
          maxLines: 1,
          textDirection: TextDirection.ltr,
        )..layout(
            minWidth: constraints.minWidth, maxWidth: constraints.maxWidth);

        final fitsOnScreen = textPainter.size.width <= constraints.maxWidth;

        return SizedBox(
          width: constraints.maxWidth,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              word,
              style: TextStyle(
                fontSize: fitsOnScreen
                    ? 40.0
                    : null,
                fontWeight: FontWeight.bold,
                color: mainTextColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.visible,
            ),
          ),
        );
      },
    );
  }
}
