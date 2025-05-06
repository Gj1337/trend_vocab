import 'package:flutter/material.dart';
import 'package:trend_vocab/src/widget/quiz_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0X004A917F)),
      ),
      home: QuizScreen(),
    ),
  );
}
