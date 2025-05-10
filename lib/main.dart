import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:trend_vocab/src/widget/audio_helper.dart';
import 'package:trend_vocab/src/widget/quiz_screen.dart';
import 'package:trend_vocab/src/widget/theme.dart';

void main() {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(
    AudioHelper(
      child: MaterialApp(
        theme: appTheme,
        darkTheme: appDarkTheme,
        home: const SafeArea(
          child: QuizScreen(onQuizControllerInit: FlutterNativeSplash.remove),
        ),
      ),
    ),
  );
}
