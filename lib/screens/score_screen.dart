import 'package:flutter/material.dart';

import 'package:hangman_game/models/score.dart';
import 'package:hangman_game/services/score_service.dart';
import 'package:hangman_game/utils/constants.dart';
import 'package:hangman_game/utils/size_config.dart';

class ScoreScreen extends StatefulWidget {
  final Map<Difficulty, List<Score>> highScores;

  const ScoreScreen({
    super.key,
    required this.highScores,
  });

  @override
  State<ScoreScreen> createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> {
  Difficulty _currentDifficulty = Difficulty.easy;

  final List<Difficulty> _difficultiesOrder = [
    Difficulty.easy,
    Difficulty.medium,
    Difficulty.hard,
  ];

  void _changeDifficulty(bool isNext) {
    setState(() {
      int currentIndex = _difficultiesOrder.indexOf(_currentDifficulty);
      if (isNext) {
        if (currentIndex < _difficultiesOrder.length - 1) {
          _currentDifficulty = _difficultiesOrder[currentIndex + 1];
        }
      } else {
        if (currentIndex > 0) {
          _currentDifficulty = _difficultiesOrder[currentIndex - 1];
        }
      }
    });
  }

  String _difficultyToString(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.easy:
        return 'Easy';
      case Difficulty.medium:
        return 'Medium';
      case Difficulty.hard:
        return 'Hard';
      default:
        return '';
    }
  }

  List<DataRow> _createRows(List<Score>? scores) {
    return List.generate(
      scores?.length ?? 0,
      (index) {
        final score = scores![index];
        return DataRow(
          cells: [
            DataCell(
              Center(
                child: Text(
                  index == 0
                      ? '🥇 ${index + 1}'
                      : index == 1
                          ? '🥈 ${index + 1}'
                          : index == 2
                              ? '🥉 ${index + 1}'
                              : '${index + 1}',
                  style: smallTextStyle,
                ),
              ),
            ),
            DataCell(
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getWidth(8.0),
                    vertical: getHeight(8.0),
                  ),
                  child: Text(
                    score.date,
                    style: smallTextStyle,
                  ),
                ),
              ),
            ),
            DataCell(
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getWidth(8.0),
                    vertical: getHeight(8.0),
                  ),
                  child: Text(
                    ScoreService().getTimerInFormat(score.time),
                    style: smallTextStyle,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: mainBackgroundColor,
        body: SafeArea(
          minimum: EdgeInsets.symmetric(
            horizontal: getWidth(24.0),
            vertical: getHeight(24.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Center(
                  child: Text(
                    'High Scores',
                    style: headerTextStyle,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                      onPressed: _currentDifficulty == Difficulty.easy
                          ? null
                          : () => _changeDifficulty(false),
                      icon: Icon(
                        Icons.arrow_back,
                        size: getHeight(32.0),
                        color: _currentDifficulty == Difficulty.easy
                            ? Colors.grey
                            : mainTextColor,
                      ),
                    ),
                    Text(
                      _difficultyToString(_currentDifficulty),
                      style: normalTextStyle,
                    ),
                    IconButton(
                      onPressed: _currentDifficulty == Difficulty.hard
                          ? null
                          : () => _changeDifficulty(true),
                      icon: Icon(
                        Icons.arrow_forward,
                        size: getHeight(32.0),
                        color: _currentDifficulty == Difficulty.hard
                            ? Colors.grey
                            : mainTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 6,
                child: SingleChildScrollView(
                  child: Center(
                    child: DataTable(
                      columns: [
                        DataColumn(
                          label: Expanded(
                            child: Center(
                              child: Text(
                                'Rank',
                                style: smallHeaderStyle,
                              ),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Expanded(
                            child: Center(
                              child: Text(
                                'Date',
                                style: smallHeaderStyle,
                              ),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Expanded(
                            child: Center(
                              child: Text(
                                'Time',
                                style: smallHeaderStyle,
                              ),
                            ),
                          ),
                        ),
                      ],
                      rows: _createRows(widget.highScores[_currentDifficulty]),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context);
          },
          backgroundColor: mainButtonColor,
          foregroundColor: mainTextColor,
          child: const Icon(Icons.home),
        ),
      ),
    );
  }
}
