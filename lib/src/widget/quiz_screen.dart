import 'package:flutter/material.dart';
import 'package:trend_vocab/src/controller/quiz_controller.dart';
import 'package:trend_vocab/src/entity/quiz.dart';
import 'package:trend_vocab/src/widget/audio_helper.dart';
import 'package:trend_vocab/src/widget/audio_icon.dart';
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

  Quiz? _currentQuiz;
  Quiz? _nextQuiz;

  var _quizAnswerStatus = _QuizAnswerStatus.wait;

  Future<void> _precacheImage() async {
    final nextQuizImage = _nextQuiz?.expression.image;
    if (nextQuizImage != null) {
      await precacheImage(AssetImage(nextQuizImage), context);
    }

    final currentQuizImage = _currentQuiz?.expression.image;
    if (currentQuizImage != null) {
      // ignore: use_build_context_synchronously
      await precacheImage(AssetImage(currentQuizImage), context);
    }
  }

  Future<void> _updateQuiz() async {
    try {
      _quizAnswerStatus = _QuizAnswerStatus.wait;
      _currentQuiz = _nextQuiz ?? _quizController.getNextQuiz();
      _nextQuiz = _quizController.getNextQuiz();

      await _precacheImage();
    } on QuizController {
      //TODO: process exception
    } finally {
      setState(() {});
    }
  }

  Future<void> _playAudio(Quiz quiz) async {
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

    await _playAudio(quiz);
  }

  Future<void> _init() async {
    await _quizController.init();
    await _updateQuiz();

    widget.onQuizControllerInit?.call();
  }

  @override
  void initState() {
    super.initState();

    _init();
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
          _currentQuiz != null
              ? AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: Padding(
                  key: ObjectKey(_currentQuiz),
                  padding: const EdgeInsets.all(10),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Column(
                      children: [
                        Expanded(
                          child: QuizWidget(
                            isAnswered: accept != null,
                            quiz: _currentQuiz!,
                            overlayIcon: AudioIcon(
                              color: Theme.of(context).primaryColor,
                              audioPlayer: context.aduiotPlayer,
                            ),
                            onQuizAnswer: _onQuizAnswer,
                            onPictureTap: () => _playAudio(_currentQuiz!),
                          ),
                        ),
                        Visibility(
                          maintainSize: true,
                          maintainAnimation: true,
                          maintainState: true,
                          visible: accept != null,
                          child: ElevatedButton(
                            onPressed: () {
                              _updateQuiz();
                              _precacheImage();
                            },
                            child: const Center(child: Text('Next')),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              : const CircularProgressIndicator(),
          TickCrossAnimationWrapper(accept: accept),
        ],
      ),
    );
  }
}
