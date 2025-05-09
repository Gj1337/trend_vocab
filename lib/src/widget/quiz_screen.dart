import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:trend_vocab/src/controller/quiz_controller.dart';
import 'package:trend_vocab/src/entity/quiz.dart';
import 'package:trend_vocab/src/widget/background_animation_wrapper.dart';

enum _QuizAnswerStatus { wait, wrong, correct }

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen>
    with SingleTickerProviderStateMixin {
  final quizController = QuizController();
  Quiz? quiz;
  var _quizAnswerStatus = _QuizAnswerStatus.wait;

  late final AnimationController animationController;

  void updateQuiz() {
    try {
      quiz = null;
      _quizAnswerStatus = _QuizAnswerStatus.wait;

      quiz = quizController.getNextQuiz();
    } on QuizController {
      //TODO: process exception
    } finally {
      setState(() {});
    }
  }

  void onQuizAnswer(Quiz quiz, String answer) {
    final isAnswerRight = quizController.chechAnswer(quiz, answer);

    setState(() {
      _quizAnswerStatus =
          isAnswerRight ? _QuizAnswerStatus.correct : _QuizAnswerStatus.wrong;
    });

    Future.delayed(Duration(seconds: 1)).then((_) {
      updateQuiz();
    });
  }

  @override
  void initState() {
    animationController = AnimationController(vsync: this);

    quizController.init().then((_) => updateQuiz());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BackgroundAnimationWrapper(
            accept: switch (_quizAnswerStatus) {
              _QuizAnswerStatus.wait => null,
              _QuizAnswerStatus.wrong => false,
              _QuizAnswerStatus.correct => true,
            },
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 500),
                    child:
                        quiz == null
                            ? CircularProgressIndicator()
                            : QuizWidget(
                              key: ObjectKey(quiz),
                              quiz: quiz!,
                              onQuizAnswer: onQuizAnswer,
                            ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class QuizWidget extends StatefulWidget {
  const QuizWidget({super.key, required this.quiz, this.onQuizAnswer});

  final Quiz quiz;
  final void Function(Quiz quiz, String answer)? onQuizAnswer;

  @override
  State<QuizWidget> createState() => _QuizWidgetState();
}

class _QuizWidgetState extends State<QuizWidget> {
  var isAnswered = false;

  @override
  void didUpdateWidget(covariant QuizWidget oldWidget) {
    if (oldWidget.quiz != widget.quiz) {
      isAnswered = false;
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          enabled: !isAnswered,
          child: Text(
            widget.quiz.expression.name,
            style: TextStyle(fontSize: 24),
          ),
        ),
        Flexible(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 500, maxWidth: 500),
            child: Image.asset(
              key: ValueKey(widget.quiz.expression.image),
              widget.quiz.expression.image,
            ),
          ),
        ),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children:
              widget.quiz.possibleVariants
                  .map(
                    (variant) => OutlinedButton(
                      onPressed: () {
                        widget.onQuizAnswer?.call(widget.quiz, variant);

                        setState(() => isAnswered = true);
                      },
                      child: Text(variant),
                    ),
                  )
                  .toList(),
        ),
      ],
    );
  }
}
