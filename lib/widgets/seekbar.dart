import 'dart:math';

import 'package:flutter/material.dart';

class SeekBarData {
  final Duration position;
  final Duration duration;

  SeekBarData({required this.position, required this.duration});
}

class SeekBar extends StatefulWidget {
  final Duration position;
  final Duration duration;
  final ValueChanged<Duration>? onchange;
  final ValueChanged<Duration>? onchangeEnd;
  const SeekBar({Key? key, required this.position, required this.duration, this.onchange, this.onchangeEnd}) : super(key: key);

  @override
  State<SeekBar> createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  double? dragValue;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(formatDuration(widget.position)),
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
                trackHeight: 4,
                thumbShape: const RoundSliderThumbShape(
                  disabledThumbRadius: 4,
                  enabledThumbRadius: 4,
                ),
                overlayShape: const RoundSliderOverlayShape(
                  overlayRadius: 10,
                ),
                activeTrackColor: Colors.white.withOpacity(0.6),
                inactiveTrackColor: Colors.white,
                thumbColor: Colors.white,
                overlayColor: Colors.white),
            child: Slider(
              min: 0.0,
              max: widget.duration.inMilliseconds.toDouble(),
              value: min(
                dragValue ?? widget.position.inMilliseconds.toDouble(),
                widget.duration.inMilliseconds.toDouble(),
              ),
              onChanged: (value) {
                setState(() {
                  dragValue = value;
                });
                if (widget.onchange != null) {
                  widget.onchange!(Duration(milliseconds: value.round()));
                }
              },
              onChangeEnd: (value) {
                if (widget.onchangeEnd != null) {
                  widget.onchangeEnd!(Duration(milliseconds: value.round()));
                }
                setState(() {
                  dragValue = null;
                });
              },
            ),
          ),
        ),
        Text(formatDuration(widget.duration)),
      ],
    );
  }

  formatDuration(Duration? duration) {
    if (duration == null) {
      return "00:00";
    } else {
      String minutes = duration.inMinutes.toString().padLeft(2, '0');
      String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
      return "$minutes:$seconds";
    }
  }
}
