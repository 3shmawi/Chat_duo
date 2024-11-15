// import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../app/functions.dart';

class AudioMessageWidget extends StatefulWidget {
  final String audioUrl;
  final String date;
  final bool isSender;

  const AudioMessageWidget({
    super.key,
    required this.audioUrl,
    required this.isSender,
    required this.date,
  });

  @override
  AudioMessageWidgetState createState() => AudioMessageWidgetState();
}

class AudioMessageWidgetState extends State<AudioMessageWidget> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  bool isLoading = true;
  Duration position = Duration.zero;
  Duration duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer.onDurationChanged.listen((d) {
      setState(() {
        duration = d;
      });
    });
    _audioPlayer.onPositionChanged.listen((p) {
      setState(() {
        position = p;
      });
    });
    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  // Function to toggle play/pause
  void _togglePlayPause() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(UrlSource(widget.audioUrl));
    }
  }

  // Function to seek audio
  void _seekAudio(double value) {
    final position = Duration(seconds: value.toInt());
    _audioPlayer.seek(position);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          widget.isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        _buildAudioPlayer(),
      ],
    );
  }

  Widget _buildAudioPlayer() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: widget.isSender ? Colors.red : Colors.grey,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Waveform display

          // AudioWave(
          //   audioUrl: widget.audioUrl,
          // ),
          // Play/pause button and progress bar
          Row(
            children: [
              IconButton(
                icon: Icon(
                  isPlaying ? CupertinoIcons.pause : CupertinoIcons.play,
                  color: widget.isSender ? Colors.red : Colors.grey,
                ),
                onPressed: _togglePlayPause,
              ),
              Slider(
                value: position.inMicroseconds.toDouble(),
                max: duration.inMicroseconds.toDouble(),
                inactiveColor: Colors.grey.shade300,
                activeColor: widget.isSender ? Colors.red : Colors.grey,
                thumbColor: widget.isSender ? Colors.red : Colors.grey,
                onChanged: _seekAudio,
              ),
            ],
          ),
          Text(
            daysBetween(widget.date),
            style: TextStyle(
              color: widget.isSender ? Colors.grey.shade500 : Colors.black45,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
