import 'package:flutter/material.dart';
import '../widgets/volume_control_sidebar.dart';

/// Example of using the SliderControlSidebar widget for various purposes.
class SliderControlExamples extends StatefulWidget {
  const SliderControlExamples({super.key});

  @override
  State<SliderControlExamples> createState() => _SliderControlExamplesState();
}

class _SliderControlExamplesState extends State<SliderControlExamples> {
  // Values for different controls
  double _volume = 0.5;
  double _brightness = 0.7;
  double _opacity = 0.8;
  double _temperature = 22.5;
  
  // Visibility flags for different controls
  bool _isVolumeControlVisible = false;
  bool _isBrightnessControlVisible = false;
  bool _isOpacityControlVisible = false;
  bool _isTemperatureControlVisible = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Slider Control Examples'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Example buttons to toggle different controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildControlButton(
                  'Volume',
                  Icons.volume_up,
                  _isVolumeControlVisible,
                  () => setState(() {
                    _isVolumeControlVisible = !_isVolumeControlVisible;
                    // Close other controls
                    _isBrightnessControlVisible = false;
                    _isOpacityControlVisible = false;
                    _isTemperatureControlVisible = false;
                  }),
                ),
                _buildControlButton(
                  'Brightness',
                  Icons.brightness_6,
                  _isBrightnessControlVisible,
                  () => setState(() {
                    _isBrightnessControlVisible = !_isBrightnessControlVisible;
                    // Close other controls
                    _isVolumeControlVisible = false;
                    _isOpacityControlVisible = false;
                    _isTemperatureControlVisible = false;
                  }),
                ),
                _buildControlButton(
                  'Opacity',
                  Icons.opacity,
                  _isOpacityControlVisible,
                  () => setState(() {
                    _isOpacityControlVisible = !_isOpacityControlVisible;
                    // Close other controls
                    _isVolumeControlVisible = false;
                    _isBrightnessControlVisible = false;
                    _isTemperatureControlVisible = false;
                  }),
                ),
                _buildControlButton(
                  'Temperature',
                  Icons.thermostat,
                  _isTemperatureControlVisible,
                  () => setState(() {
                    _isTemperatureControlVisible = !_isTemperatureControlVisible;
                    // Close other controls
                    _isVolumeControlVisible = false;
                    _isBrightnessControlVisible = false;
                    _isOpacityControlVisible = false;
                  }),
                ),
              ],
            ),
            const SizedBox(height: 30),
            
            // Display current values
            Text('Volume: ${(_volume * 100).toInt()}%'),
            Text('Brightness: ${(_brightness * 100).toInt()}%'),
            Text('Opacity: ${(_opacity * 100).toInt()}%'),
            Text('Temperature: ${_temperature.toStringAsFixed(1)}°C'),
            
            const SizedBox(height: 30),
            
            // Stack of all controls (only one will be visible at a time)
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                // Volume control using the specialized VolumeControlSidebar
                VolumeControlSidebar(
                  soundId: 'example_sound',
                  soundName: 'Volume',
                  isVisible: _isVolumeControlVisible,
                  volume: _volume,
                  onVolumeChanged: (value) => setState(() => _volume = value),
                  onClose: () => setState(() => _isVolumeControlVisible = false),
                ),
                
                // Brightness control using the generic SliderControlSidebar
                SliderControlSidebar(
                  id: 'brightness',
                  title: 'Brightness',
                  isVisible: _isBrightnessControlVisible,
                  value: _brightness,
                  icon: Icons.brightness_6,
                  onChanged: (value) => setState(() => _brightness = value),
                  onClose: () => setState(() => _isBrightnessControlVisible = false),
                ),
                
                // Opacity control using the generic SliderControlSidebar
                SliderControlSidebar(
                  id: 'opacity',
                  title: 'Opacity',
                  isVisible: _isOpacityControlVisible,
                  value: _opacity,
                  icon: Icons.opacity,
                  onChanged: (value) => setState(() => _opacity = value),
                  onClose: () => setState(() => _isOpacityControlVisible = false),
                ),
                
                // Temperature control using the generic SliderControlSidebar
                SliderControlSidebar(
                  id: 'temperature',
                  title: 'Temperature',
                  isVisible: _isTemperatureControlVisible,
                  value: _temperature,
                  minValue: 16.0,
                  maxValue: 30.0,
                  divisions: 28,
                  valueFormat: '°C',
                  showAsPercentage: false,
                  icon: Icons.thermostat,
                  onChanged: (value) => setState(() => _temperature = value),
                  onClose: () => setState(() => _isTemperatureControlVisible = false),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildControlButton(
    String label,
    IconData icon,
    bool isActive,
    VoidCallback onPressed,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: isActive ? Colors.blueAccent : null,
          foregroundColor: isActive ? Colors.white : null,
        ),
      ),
    );
  }
}
