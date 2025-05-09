import 'package:flutter/material.dart';
import 'package:trend_vocab/src/widget/quiz_screen.dart';
import 'package:trend_vocab/src/widget/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      theme: appTheme,
      darkTheme: appDarkTheme,
      home: const SafeArea(child: QuizScreen()),
    ),
  );
}
