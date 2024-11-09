// import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AudioMessageWidget extends StatefulWidget {
  final String audioUrl;
  final bool isSender;

  const AudioMessageWidget({
    super.key,
    required this.audioUrl,
    required this.isSender,
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        mainAxisAlignment:
            widget.isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (widget.isSender) ...[
            _buildAudioPlayer(),
          ] else ...[
            _buildAudioPlayer(),
          ],
        ],
      ),
    );
  }

  Widget _buildAudioPlayer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.red,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Waveform display

          // AudioWave(
          //   audioUrl: widget.audioUrl,
          // ),
          const SizedBox(height: 5),
          // Play/pause button and progress bar
          Row(
            children: [
              IconButton(
                icon: Icon(
                  isPlaying ? CupertinoIcons.pause : CupertinoIcons.play,
                  color: Colors.red,
                ),
                onPressed: _togglePlayPause,
              ),
              Slider(
                value: position.inMicroseconds.toDouble(),
                max: duration.inMicroseconds.toDouble(),
                inactiveColor: Colors.grey.shade300,
                onChanged: _seekAudio,
              ),
              Text(duration.inSeconds.toString())
            ],
          ),
        ],
      ),
    );
  }
}
