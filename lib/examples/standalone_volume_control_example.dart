import 'package:flutter/material.dart';
import '../widgets/volume_control_sidebar.dart';

/// Example of using the VolumeControlSidebar widget in a standalone way.
class StandaloneVolumeControlExample extends StatefulWidget {
  const StandaloneVolumeControlExample({super.key});

  @override
  State<StandaloneVolumeControlExample> createState() => _StandaloneVolumeControlExampleState();
}

class _StandaloneVolumeControlExampleState extends State<StandaloneVolumeControlExample> {
  double _volume = 0.5;
  bool _isVolumeControlVisible = false;
  String _activeSoundId = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Volume Control Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Example sound button
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isVolumeControlVisible = !_isVolumeControlVisible;
                  _activeSoundId = 'example_sound';
                });
              },
              child: const Text('Toggle Volume Control'),
            ),
            const SizedBox(height: 20),
            // Display current volume
            Text('Current Volume: ${(_volume * 100).toInt()}%'),
            const SizedBox(height: 20),
            // Volume control sidebar
            VolumeControlSidebar(
              soundId: 'example_sound',
              soundName: 'Example Sound',
              isVisible: _isVolumeControlVisible && _activeSoundId == 'example_sound',
              volume: _volume,
              minVolume: 0.0,
              maxVolume: 1.0,
              divisions: 20,
              onVolumeChanged: (double value) {
                setState(() {
                  _volume = value;
                });
              },
              onClose: () {
                setState(() {
                  _isVolumeControlVisible = false;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
