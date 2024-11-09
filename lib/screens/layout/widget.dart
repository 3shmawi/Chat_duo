import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';

class AudioWave extends StatelessWidget {
  const AudioWave({super.key});

  @override
  Widget build(BuildContext context) {
    return AudioWaveforms(
      size: Size(MediaQuery.of(context).size.width * 0.5, 50),
      recorderController: RecorderController(),
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
    );
  }
}
