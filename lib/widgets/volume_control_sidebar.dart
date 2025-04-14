import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// A generic slider control sidebar that can be used for various purposes.
///
/// This widget provides a customizable slider with min and max values, and calls
/// the provided onChange callback when the value is adjusted. It can be used for
/// volume control, brightness, opacity, or any other numeric value adjustment.
class SliderControlSidebar extends StatefulWidget {
  /// A unique identifier for this control.
  final String id;

  /// The title displayed at the top of the control.
  final String title;

  /// Whether the control is visible.
  final bool isVisible;

  /// The current value of the slider.
  final double value;

  /// The minimum value of the slider.
  final double minValue;

  /// The maximum value of the slider.
  final double maxValue;

  /// The number of discrete divisions for the slider.
  final int divisions;

  /// The format to display the current value (e.g., '%', 'px', etc.)
  final String valueFormat;

  /// Whether to show the value as a percentage of the max value.
  final bool showAsPercentage;

  /// The icon to display for the slider (optional).
  final IconData? icon;

  /// The color of the active portion of the slider.
  final Color activeColor;

  /// The color of the inactive portion of the slider.
  final Color inactiveColor;

  /// The width of the control sidebar.
  final double width;

  /// The height of the control sidebar.
  final double height;

  /// Callback when the slider value changes.
  final ValueChanged<double> onChanged;

  /// Callback when the close button is pressed.
  final VoidCallback onClose;

  const SliderControlSidebar({
    super.key,
    required this.id,
    required this.title,
    required this.isVisible,
    required this.value,
    this.minValue = 0.0,
    this.maxValue = 1.0,
    this.divisions = 20,
    this.valueFormat = '%',
    this.showAsPercentage = true,
    this.icon,
    this.activeColor = Colors.white,
    this.inactiveColor = Colors.white54,
    this.width = 130,
    this.height = 150,
    required this.onChanged,
    required this.onClose,
  });

  @override
  State<SliderControlSidebar> createState() => _SliderControlSidebarState();
}

class _SliderControlSidebarState extends State<SliderControlSidebar> {
  @override
  Widget build(BuildContext context) {
    // Only show if the control is visible
    if (!widget.isVisible) {
      return const SizedBox.shrink();
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: widget.width,
      height: widget.height,
      constraints: BoxConstraints(maxHeight: widget.height * 1.5),
      decoration: BoxDecoration(
        color: AppColors.primaryBackground.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: 16),
            // Title at the top
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (widget.icon != null) ...<Widget>[
                    Icon(
                      widget.icon,
                      color: Colors.white,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                  ],
                  Flexible(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Horizontal slider
            SizedBox(
              width: widget.width - 20, // Padding on both sides
              child: Slider(
                value: widget.value,
                min: widget.minValue,
                max: widget.maxValue,
                divisions: widget.divisions,
                activeColor: widget.activeColor,
                inactiveColor: widget.inactiveColor,
                onChanged: widget.onChanged,
              ),
            ),
            const SizedBox(height: 16),
            // Value display
            Text(
              widget.showAsPercentage
                  ? '${(((widget.value - widget.minValue) / (widget.maxValue - widget.minValue)) * 100).toInt()}${widget.valueFormat}'
                  : '${widget.value.toStringAsFixed(1)}${widget.valueFormat}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 16),
            // Close button
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 16),
              onPressed: widget.onClose,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

/// A specialized version of SliderControlSidebar specifically for volume control.
///
/// This is a convenience wrapper around SliderControlSidebar that sets defaults
/// appropriate for volume control.
class VolumeControlSidebar extends StatelessWidget {
  /// The unique identifier for the sound.
  final String soundId;

  /// The display name of the sound.
  final String soundName;

  /// Whether the volume control is visible.
  final bool isVisible;

  /// The current volume value.
  final double volume;

  /// The minimum volume value.
  final double minVolume;

  /// The maximum volume value.
  final double maxVolume;

  /// The number of discrete divisions for the slider.
  final int divisions;

  /// Callback when the volume changes.
  final ValueChanged<double> onVolumeChanged;

  /// Callback when the close button is pressed.
  final VoidCallback onClose;

  const VolumeControlSidebar({
    super.key,
    required this.soundId,
    required this.soundName,
    required this.isVisible,
    required this.volume,
    this.minVolume = 0.0,
    this.maxVolume = 1.0,
    this.divisions = 20,
    required this.onVolumeChanged,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return SliderControlSidebar(
      id: soundId,
      title: soundName,
      isVisible: isVisible,
      value: volume,
      minValue: minVolume,
      maxValue: maxVolume,
      divisions: divisions,
      valueFormat: '%',
      showAsPercentage: true,
      icon: Icons.volume_up,
      onChanged: onVolumeChanged,
      onClose: onClose,
    );
  }
}
