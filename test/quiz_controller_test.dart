import 'package:flutter_test/flutter_test.dart';
import 'package:trend_vocab/src/controller/quiz_controller.dart';
import 'package:trend_vocab/src/entity/expression.dart';
import 'package:trend_vocab/src/controller/quiz_controller_exceptions.dart';

void main() {
  // Initialize the binding before running any tests
  TestWidgetsFlutterBinding.ensureInitialized();

  group('QuizController Tests', () {
    late QuizController quizController;

    setUp(() async {
      quizController = QuizController();
      await quizController.init(); // Make sure initialization is done
    });

    // Test initialization
    test('QuizController initializes correctly', () async {
      // Before initialization, the controller should not be initialized
      expect(quizController.isInitialized, true);
      expect(quizController.expressions.isNotEmpty, true);
    });

    // Test if getNextQuiz returns a valid quiz
    test('getNextQuiz returns a valid quiz', () async {
      const possibleVariantsCount = 4;
      final quiz = quizController.getNextQuiz();

      // Check if the returned quiz contains an expression and possible variants
      expect(quiz.expression, isNotNull);
      expect(quiz.possibleVariants, isNotEmpty);
      expect(quiz.possibleVariants.length, possibleVariantsCount);
    });

    // Test that the quiz variants do not include the same expression more than once
    test('getNextQuiz does not duplicate expressions in variants', () async {
      final quiz = quizController.getNextQuiz();

      // Ensure the current expression is not duplicated in the possible variants
      expect(quiz.possibleVariants.contains(quiz.expression.name), true);
      expect(
        quiz.possibleVariants.where((e) => e == quiz.expression.name).length,
        1,
      );
    });

    // Test chechAnswer correctly checks the answer
    test('chechAnswer correctly checks the answer', () async {
      final quiz = quizController.getNextQuiz();

      // Correct answer should return true
      expect(quizController.chechAnswer(quiz, quiz.expression.name), true);

      // Incorrect answer should return false
      expect(quizController.chechAnswer(quiz, 'Wrong Answer'), false);
    });

    // Test if all expressions are shuffled correctly
    test('expressions are shuffled after initialization', () async {
      // Save the initial order of expressions
      final initialOrder = List.from(quizController.expressions);

      // Reinitialize the controller and check if the order is shuffled
      await quizController.init();
      final shuffledOrder = quizController.expressions;

      // Ensure that the order is different
      expect(initialOrder, isNot(shuffledOrder));
    });

    // Test if QuizNotInitializedException is thrown before initialization
    test('throws QuizNotInitializedException if not initialized', () async {
      final quizControllerNotInitialized = QuizController();

      // Trying to get a quiz before initialization should throw an exception
      expect(
        () => quizControllerNotInitialized.getNextQuiz(),
        throwsA(isInstanceOf<QuizNotInitializedException>()),
      );

      // Trying to check an answer before initialization should also throw an exception
      final quiz = quizController.getNextQuiz();
      expect(
        () => quizControllerNotInitialized.chechAnswer(quiz, 'some answer'),
        throwsA(isInstanceOf<QuizNotInitializedException>()),
      );
    });

    // Test getNextQuiz works with custom number of variants
    test('getNextQuiz works with custom number of variants', () async {
      final quiz = quizController.getNextQuiz(possibleVariantsCount: 6);

      // Check if the quiz has the correct number of possible variants
      expect(quiz.possibleVariants.length, 6);
    });

    // Test expressionsPointer wraps around correctly
    test('expressionsPointer wraps around correctly', () async {
      final firstQuiz = quizController.getNextQuiz();
      final firstExpression = firstQuiz.expression;

      // Run through all the expressions
      for (int i = 1; i < quizController.expressions.length; i++) {
        quizController.getNextQuiz();
      }

      // The next quiz after the last one should be the first expression again
      final quizAfterLast = quizController.getNextQuiz();
      expect(quizAfterLast.expression, firstExpression);
    });

    // Test if all expressions are given at least once
    test('All expressions are given at least once', () async {
      final usedExpressions = <Expression>[];

      // Run enough quizzes to cover all expressions
      for (int i = 0; i < quizController.expressions.length; i++) {
        final quiz = quizController.getNextQuiz();
        final currentExpression = quiz.expression;

        if (!usedExpressions.contains(currentExpression)) {
          usedExpressions.add(currentExpression);
        }
      }

      // Check if all expressions were used
      expect(
        usedExpressions.length,
        quizController.expressions.length,
        reason: 'Not all expressions were used',
      );
    });
  });
}
