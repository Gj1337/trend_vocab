import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioIcon extends StatelessWidget {
  const AudioIcon({
    required this.audioPlayer,
    this.twinkDuration = const Duration(milliseconds: 250),
    this.size = 150,
    super.key,
    this.color,
  });

  final AudioPlayer audioPlayer;
  final Duration twinkDuration;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) => StreamBuilder(
    stream: audioPlayer.playerStateStream,
    builder: (context, snapshot) {
      final playerState = snapshot.data;

      return playerState?.playing == true
          ? _PlayingIcon(twinkDuration: twinkDuration, size: size, color: color)
          : const SizedBox();
    },
  );
}

class _PlayingIcon extends StatefulWidget {
  const _PlayingIcon({
    required this.size,
    required this.twinkDuration,
    this.color,
  });

  final Duration twinkDuration;
  final double size;
  final Color? color;

  @override
  State<_PlayingIcon> createState() => _PlayingIconState();
}

class _PlayingIconState extends State<_PlayingIcon>
    with SingleTickerProviderStateMixin {
  late final Timer _timer;

  final _icons = <IconData>[
    Icons.volume_mute_rounded,
    Icons.volume_down_rounded,
    Icons.volume_up_rounded,
  ];
  var _index = 0;

  void _onTimerTick(Timer timer) =>
      setState(() => _index = (_index + 1) % _icons.length);

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(widget.twinkDuration, _onTimerTick);
  }

  @override
  void dispose() {
    _timer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      Icon(_icons[_index], size: widget.size, color: widget.color);
}
