import 'package:flutter/material.dart';
import 'package:trend_vocab/src/controller/quiz_controller.dart';
import 'package:trend_vocab/src/entity/quiz.dart';
import 'package:trend_vocab/src/widget/audio_helper.dart';
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
  final _quizController = QuizController();

  Quiz? _quiz;
  var _quizAnswerStatus = _QuizAnswerStatus.wait;

  void _updateQuiz() {
    try {
      _quiz = null;
      _quizAnswerStatus = _QuizAnswerStatus.wait;

      _quiz = _quizController.getNextQuiz();
    } on QuizController {
      //TODO: process exception
    } finally {
      widget.onQuizControllerInit?.call();
      setState(() {});
    }
  }

  Future<void> playAudio(Quiz quiz) async {
    try {
      context.aduiotPlayer.playExpression(quiz.expression);
    } catch (problem) {
      print('Can\'t play audio $problem.');
    }
  }

  Future<void> _onQuizAnswer(Quiz quiz, String answer) async {
    final isAnswerRight = _quizController.chechAnswer(quiz, answer);

    setState(() {
      _quizAnswerStatus =
          isAnswerRight ? _QuizAnswerStatus.correct : _QuizAnswerStatus.wrong;
    });

    await playAudio(quiz);

    await Future.delayed(const Duration(seconds: 1));
    _updateQuiz();
  }

  @override
  void initState() {
    _quizController.init().then((_) => _updateQuiz());

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
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child:
                _quiz != null
                    ? Padding(
                      key: ObjectKey(_quiz),
                      padding: const EdgeInsets.all(10),
                      child: QuizWidget(
                        isAnswered: accept != null,
                        quiz: _quiz!,
                        onQuizAnswer: _onQuizAnswer,
                        onPictureTap: () => playAudio(_quiz!),
                      ),
                    )
                    : const CircularProgressIndicator(),
          ),
          TickCrossAnimationWrapper(accept: accept),
        ],
      ),
    );
  }
}
