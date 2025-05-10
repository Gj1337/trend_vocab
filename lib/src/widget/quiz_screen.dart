import 'package:flutter/material.dart';
import 'package:trend_vocab/src/controller/quiz_controller.dart';
import 'package:trend_vocab/src/entity/quiz.dart';
import 'package:trend_vocab/src/widget/background_animation_wrapper.dart';
import 'package:trend_vocab/src/widget/quiz_widget.dart';
import 'package:trend_vocab/src/widget/tick_cross_animation_wrapper.dart';

enum _QuizAnswerStatus { wait, wrong, correct }

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key, this.onQuizControllerInit});

  final void Function()? onQuizControllerInit;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen>
    with SingleTickerProviderStateMixin {
  final quizController = QuizController();

  Quiz? quiz;
  var _quizAnswerStatus = _QuizAnswerStatus.wait;

  void _updateQuiz() {
    try {
      quiz = null;
      _quizAnswerStatus = _QuizAnswerStatus.wait;

      quiz = quizController.getNextQuiz();
    } on QuizController {
      //TODO: process exception
    } finally {
      widget.onQuizControllerInit?.call();
      setState(() {});
    }
  }

  void _onQuizAnswer(Quiz quiz, String answer) {
    final isAnswerRight = quizController.chechAnswer(quiz, answer);

    setState(() {
      _quizAnswerStatus =
          isAnswerRight ? _QuizAnswerStatus.correct : _QuizAnswerStatus.wrong;
    });

    Future.delayed(const Duration(seconds: 1)).then((_) {
      _updateQuiz();
    });
  }

  @override
  void initState() {
    quizController.init().then((_) => _updateQuiz());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final accept = switch (_quizAnswerStatus) {
      _QuizAnswerStatus.wait => null,
      _QuizAnswerStatus.wrong => false,
      _QuizAnswerStatus.correct => true,
    };

    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          BackgroundAnimationWrapper(accept: accept),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child:
                  quiz != null
                      ? Padding(
                        key: ObjectKey(quiz),
                        padding: const EdgeInsets.all(10),
                        child: QuizWidget(
                          quiz: quiz!,
                          onQuizAnswer: _onQuizAnswer,
                        ),
                      )
                      : const CircularProgressIndicator(),
            ),
          ),
          TickCrossAnimationWrapper(accept: accept),
        ],
      ),
    );
  }
}
