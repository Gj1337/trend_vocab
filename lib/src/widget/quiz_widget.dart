import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:trend_vocab/src/entity/quiz.dart';

class QuizWidget extends StatefulWidget {
  const QuizWidget({required this.quiz, super.key, this.onQuizAnswer});

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
  Widget build(BuildContext context) => Column(
    spacing: 15,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      QuizExpressionText(quiz: widget.quiz, isAnswered: isAnswered),
      Flexible(child: QuizPicture(quiz: widget.quiz)),
      SizedBox(
        width: 800,
        child: QuizButtons(
          quiz: widget.quiz,
          onQuizAnswer: (quiz, variant) {
            widget.onQuizAnswer?.call(widget.quiz, variant);

            setState(() => isAnswered = true);
          },
        ),
      ),
    ],
  );
}

class QuizExpressionText extends StatelessWidget {
  const QuizExpressionText({
    required this.quiz,
    required this.isAnswered,
    super.key,
  });

  final Quiz quiz;
  final bool isAnswered;

  @override
  Widget build(BuildContext context) => ImageFiltered(
    imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
    enabled: !isAnswered,
    child: Text(
      quiz.expression.name,
      style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    ),
  );
}

class QuizPicture extends StatelessWidget {
  const QuizPicture({required this.quiz, super.key});

  final Quiz quiz;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      border: Border.all(color: Theme.of(context).primaryColor, width: 4),
      borderRadius: BorderRadius.circular(20),
    ),
    constraints: const BoxConstraints(maxHeight: 500, maxWidth: 500),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.asset(
        key: ValueKey(quiz.expression.image),
        quiz.expression.image,
      ),
    ),
  );
}

class QuizButtons extends StatelessWidget {
  const QuizButtons({required this.quiz, super.key, this.onQuizAnswer});

  final Quiz quiz;
  final void Function(Quiz quiz, String answer)? onQuizAnswer;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 10,
    alignment: WrapAlignment.center,
    runSpacing: 10,
    children:
        quiz.possibleVariants
            .map(
              (variant) => ElevatedButton(
                onPressed: () => onQuizAnswer?.call(quiz, variant),
                child: SizedBox(
                  width: 300,
                  height: 40,
                  child: Center(
                    child: Text(variant, textAlign: TextAlign.center),
                  ),
                ),
              ),
            )
            .toList(),
  );
}
