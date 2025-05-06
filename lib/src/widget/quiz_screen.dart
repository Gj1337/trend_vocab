import 'package:flutter/material.dart';
import 'package:trend_vocab/src/controller/quiz_controller.dart';
import 'package:trend_vocab/src/entity/quiz.dart';

enum _QuizAnswerStatus { wait, wrong, correct }

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final quizController = QuizController();
  Quiz? quiz;
  var _quizAnswerStatus = _QuizAnswerStatus.wait;

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
  }

  @override
  void initState() {
    quizController.init().then((_) => updateQuiz());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text(switch (_quizAnswerStatus) {
              _QuizAnswerStatus.wrong => '❌',
              _QuizAnswerStatus.correct => '✅',
              _QuizAnswerStatus.wait || _ => '',
            }),
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
            FilledButton(onPressed: updateQuiz, child: Text('Next')),
          ],
        ),
      ),
    );
  }
}

class QuizWidget extends StatelessWidget {
  const QuizWidget({super.key, required this.quiz, this.onQuizAnswer});

  final Quiz quiz;
  final void Function(Quiz quiz, String answer)? onQuizAnswer;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 500, maxWidth: 500),
            child: Image.asset(
              key: ValueKey(quiz.expression.image),
              quiz.expression.image,
            ),
          ),
        ),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children:
              quiz.possibleVariants
                  .map(
                    (variant) => OutlinedButton(
                      onPressed: () {
                        onQuizAnswer?.call(quiz, variant);
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
