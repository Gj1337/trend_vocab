import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:trend_vocab/src/entity/expression.dart';

class AudioHelper extends StatefulWidget {
  const AudioHelper({required this.child, super.key});

  final Widget child;

  static AudioPlayer? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_AudioHelper>()?.audioPlayer;

  static AudioPlayer of(BuildContext context) =>
      maybeOf(context) ??
      (throw Exception('Can\'t find AudioHelper in context'));

  @override
  State<AudioHelper> createState() => _AudioHelperState();
}

class _AudioHelperState extends State<AudioHelper> {
  final _audioPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context) =>
      _AudioHelper(audioPlayer: _audioPlayer, child: widget.child);

  @override
  void dispose() {
    super.dispose();
  }
}

class _AudioHelper extends InheritedWidget {
  const _AudioHelper({required this.audioPlayer, required super.child});

  final AudioPlayer audioPlayer;

  @override
  bool updateShouldNotify(_AudioHelper oldWidget) =>
      audioPlayer != oldWidget.audioPlayer;
}

extension AudioPlayerQuizExtention on AudioPlayer {
  Future<void> playExpression(Expression expression) async {
    await stop();
    await setAsset(expression.audio);
    await play();
    await stop();
  }
}

extension AudioHelperExtention on BuildContext {
  AudioPlayer get aduiotPlayer => AudioHelper.of(this);
}
