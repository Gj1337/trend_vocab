import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:trend_vocab/src/entity/quiz.dart';

class QuizWidget extends StatelessWidget {
  const QuizWidget({
    required this.quiz,
    required this.isAnswered,
    this.onQuizAnswer,
    this.onPictureTap,
    this.overlayIcon,
    super.key,
  });

  final Quiz quiz;
  final bool isAnswered;
  final void Function(Quiz quiz, String answer)? onQuizAnswer;
  final void Function()? onPictureTap;
  final Widget? overlayIcon;

  @override
  Widget build(BuildContext context) => _QuizProvider(
    quiz: quiz,
    onQuizAnswer: onQuizAnswer,
    onPictureTap: onPictureTap,
    isAnswered: isAnswered,
    overlayIcon: overlayIcon,

    child: Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 15,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 100,
          child: Center(child: _QuizExpressionWidget()),
        ),

        const Flexible(child: _QuizPicture()),

        SizedBox(
          height: 300,
          child: ButtonsToExamplesAnimationSwitcher(
            child:
                isAnswered ? const ExpressionExamples() : const _QuizButtons(),
          ),
        ),
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
    this.overlayIcon,
  });

  final Quiz quiz;
  final void Function(Quiz quiz, String answer)? onQuizAnswer;
  final void Function()? onPictureTap;
  final bool isAnswered;
  final Widget? overlayIcon;

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
      isAnswered != oldWidget.isAnswered ||
      overlayIcon != oldWidget.overlayIcon;
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
        style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _QuizPicture extends StatelessWidget {
  const _QuizPicture();

  @override
  Widget build(BuildContext context) {
    final _QuizProvider(
      :quiz,
      :onPictureTap,
      :isAnswered,
      :overlayIcon,
    ) = _QuizProvider.of(context);

    print(overlayIcon);

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

            if (overlayIcon != null)
              Material(color: Colors.transparent, child: overlayIcon),

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

    return Column(
      spacing: 10,
      children:
          quiz.possibleVariants
              .map(
                (variant) => ElevatedButton(
                  onPressed: () => onQuizAnswer?.call(quiz, variant),
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    child: Text(variant, textAlign: TextAlign.center),
                  ),
                ),
              )
              .toList(),
    );
  }
}

class ExpressionExamples extends StatelessWidget {
  const ExpressionExamples({super.key});

  @override
  Widget build(BuildContext context) {
    final _QuizProvider(:quiz) = _QuizProvider.of(context);
    final examples = quiz.expression.examples;

    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.center,
      children:
          examples
              .map(
                (example) =>
                    Text(example, style: const TextStyle(fontSize: 16)),
              )
              .toList(),
    );
  }
}

class ButtonsToExamplesAnimationSwitcher extends StatelessWidget {
  const ButtonsToExamplesAnimationSwitcher({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => AnimatedSwitcher(
    transitionBuilder:
        (child, animation) => FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        ),
    duration: const Duration(milliseconds: 200),
    child: child,
  );
}
