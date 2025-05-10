import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:trend_vocab/src/entity/quiz.dart';

class QuizWidget extends StatefulWidget {
  const QuizWidget({
    required this.quiz,
    required this.isAnswered,
    this.onQuizAnswer,
    this.onPictureTap,
    super.key,
  });

  final Quiz quiz;
  final bool isAnswered;
  final void Function(Quiz quiz, String answer)? onQuizAnswer;
  final void Function()? onPictureTap;

  @override
  State<QuizWidget> createState() => _QuizWidgetState();
}

class _QuizWidgetState extends State<QuizWidget> {
  @override
  Widget build(BuildContext context) => _QuizProvider(
    quiz: widget.quiz,
    onQuizAnswer: widget.onQuizAnswer,
    onPictureTap: widget.onPictureTap,
    isAnswered: widget.isAnswered,
    child: const Column(
      spacing: 15,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _QuizExpressionWidget(),
        Flexible(child: _QuizPicture()),
        SizedBox(width: 800, child: _QuizButtons()),
      ],
    ),
  );
}

class _QuizProvider extends InheritedWidget {
  const _QuizProvider({
    required this.quiz,
    required this.onQuizAnswer,
    required this.onPictureTap,
    required this.isAnswered,
    required super.child,
  });

  final Quiz quiz;
  final void Function(Quiz quiz, String answer)? onQuizAnswer;
  final void Function()? onPictureTap;
  final bool isAnswered;

  static _QuizProvider? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_QuizProvider>();

  static _QuizProvider of(BuildContext context) =>
      maybeOf(context) ??
      (throw Exception('Can\'t find _QuizProvider in context'));

  @override
  bool updateShouldNotify(_QuizProvider oldWidget) =>
      quiz != oldWidget.quiz ||
      onQuizAnswer != oldWidget.onQuizAnswer ||
      onPictureTap != oldWidget.onPictureTap ||
      isAnswered != oldWidget.isAnswered;
}

class _QuizExpressionWidget extends StatelessWidget {
  const _QuizExpressionWidget();

  @override
  Widget build(BuildContext context) {
    final _QuizProvider(:quiz, :isAnswered) = _QuizProvider.of(context);

    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      enabled: !isAnswered,
      child: Text(
        quiz.expression.name,
        style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _QuizPicture extends StatelessWidget {
  const _QuizPicture();

  @override
  Widget build(BuildContext context) {
    final _QuizProvider(:quiz, :onPictureTap, :isAnswered) = _QuizProvider.of(
      context,
    );

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor, width: 4),
        borderRadius: BorderRadius.circular(20),
      ),
      constraints: const BoxConstraints(maxHeight: 700, maxWidth: 700),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          alignment: AlignmentDirectional.topEnd,
          children: [
            Image.asset(
              fit: BoxFit.fill,
              key: ValueKey(quiz.expression.image),
              quiz.expression.image,
            ),
            if (isAnswered)
              Icon(
                Icons.volume_up_rounded,
                color: Theme.of(context).primaryColor,
                size: 150,
              ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  highlightColor: Theme.of(context).primaryColor.withAlpha(100),
                  onTap: isAnswered ? onPictureTap?.call : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuizButtons extends StatelessWidget {
  const _QuizButtons();

  @override
  Widget build(BuildContext context) {
    final _QuizProvider(:quiz, :onQuizAnswer) = _QuizProvider.of(context);

    return Wrap(
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
}
