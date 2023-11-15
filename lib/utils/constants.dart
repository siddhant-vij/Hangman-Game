import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:hangman_game/utils/size_config.dart';

const wordsFilePath = 'assets/dictionary.txt';

const numberOfScoresToSave = 5;
const minLengthEasy = 4;
const maxLengthEasy = 7;
const minLengthMedium = 8;
const maxLengthMedium = 11;
const minLengthHard = 12;

enum Difficulty {
  easy,
  medium,
  hard,
}

const mainBackgroundColor = Color(0xFF421b9b);
const mainButtonColor = Color(0xFF007AE2);
const mainTextColor = Color(0xFFFFFFFF);

final headerTextStyle = GoogleFonts.patrickHand(
  fontSize: getHeight(56.0),
  fontWeight: FontWeight.bold,
  color: mainTextColor,
  letterSpacing: 1.5,
  wordSpacing: 1.5,
);

final normalTextStyle = GoogleFonts.patrickHand(
  fontSize: getHeight(32.0),
  fontWeight: FontWeight.bold,
  color: mainTextColor,
  letterSpacing: 1.5,
  wordSpacing: 1.5,
);

final smallHeaderStyle = GoogleFonts.patrickHand(
  fontSize: getHeight(24.0),
  fontWeight: FontWeight.bold,
  color: mainTextColor,
  letterSpacing: 1.5,
  wordSpacing: 1.5,
);

final smallTextStyle = GoogleFonts.patrickHand(
  fontSize: getHeight(16.0),
  fontWeight: FontWeight.bold,
  color: mainTextColor,
  letterSpacing: 1.5,
  wordSpacing: 1.5,
);

final buttonTextStyle = GoogleFonts.patrickHand(
  fontSize: getHeight(24.0),
  fontWeight: FontWeight.bold,
  color: mainTextColor,
  letterSpacing: 1,
  wordSpacing: 1.25,
);

final buttonStyle = ElevatedButton.styleFrom(
  backgroundColor: mainButtonColor,
  fixedSize: Size(getWidth(192.0), getHeight(56.0)),
  elevation: 6.0,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(
      getRadius(8.0),
    ),
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
          text: TextSpan(
            text: word,
            style: TextStyle(
              fontSize: getHeight(40.0),
            ),
          ),
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
                fontSize: fitsOnScreen ? getHeight(40.0) : null,
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
