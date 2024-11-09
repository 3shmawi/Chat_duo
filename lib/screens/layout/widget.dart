import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioWave extends StatefulWidget {
  final String audioUrl; // Pass the audio URL as a parameter

  const AudioWave({super.key, required this.audioUrl});

  @override
  AudioWaveState createState() => AudioWaveState();
}

class AudioWaveState extends State<AudioWave> {
  late final AudioPlayer _audioPlayer;
  late final RecorderController _recorderController;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _recorderController = RecorderController();

    // Play the audio when initialized
    _audioPlayer.setSourceUrl(widget.audioUrl);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _recorderController.dispose();
    super.dispose();
  }

  void _togglePlayPause() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(UrlSource(widget.audioUrl));
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AudioWaveforms(
          size: Size(MediaQuery.of(context).size.width * 0.8, 50),
          recorderController:
              _recorderController, // This controller is for recording, but can be used for playback
          waveStyle: const WaveStyle(
            waveColor: Colors.blueAccent,
            extendWaveform: true,
            showMiddleLine: false,
          ),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(0),
        ),
        IconButton(
          icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
          onPressed: _togglePlayPause, // Toggle between play/pause
        ),
      ],
    );
  }
}
