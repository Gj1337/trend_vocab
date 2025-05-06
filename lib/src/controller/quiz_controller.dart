import 'dart:convert';
import 'dart:math';

import 'package:trend_vocab/src/controller/quiz_controller_exceptions.dart';
import 'package:trend_vocab/src/controller/expression_from_json_mapper.dart';
import 'package:trend_vocab/src/entity/expression.dart';
import 'package:trend_vocab/src/entity/quiz.dart';
import 'package:flutter/services.dart' show rootBundle;

class QuizController {
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  var _expressions = <Expression>[];
  int _expressionsPointer = 0;
  List<Expression> get expressions => _expressions;
  final _random = Random();

  Future<void> init() async {
    _isInitialized = false;

    final rawJson = await rootBundle.loadString('assets/data/expressions.json');
    final json = jsonDecode(rawJson) as List<dynamic>;

    _expressions =
        json
            .map(
              (json) =>
                  ExpressionFromJsonMapper.call(json as Map<String, dynamic>),
            )
            .toList();

    _expressions.shuffle();

    _isInitialized = true;
  }

  Quiz getNextQuiz({int possibleVariants=4}) {
    _checkInitialization();

    final currentExpression = _expressions[_expressionsPointer];
    final possibleVariants = <Expression>[currentExpression];

    while (possibleVariants.length < 4) {
      final possibleVariantIndex = _random.nextInt(expressions.length - 1);
      final possibleVariant = _expressions[possibleVariantIndex];

      final possibleVariantIsAppropriate =
          !possibleVariants.contains(possibleVariant) &&
          possibleVariant != currentExpression;

      if (possibleVariantIsAppropriate) {
        possibleVariants.add(possibleVariant);
      }
    }

    _expressionsPointer =
        _expressionsPointer == _expressions.length - 1
            ? 0
            : _expressionsPointer + 1;

    return Quiz(
      expression: currentExpression,
      possibleVariants:
          possibleVariants
              .map((possibleVariant) => possibleVariant.name)
              .toList(),
    );
  }

  bool chechAnswer(Quiz quiz, String answer) {
    _checkInitialization();

    final isAnswerRight = quiz.expression.name == answer;

    return isAnswerRight;
  }

  void _checkInitialization() {
    if (!_isInitialized) throw QuizNotInitializedException();
  }
}
