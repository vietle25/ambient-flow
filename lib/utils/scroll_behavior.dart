import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Custom scroll behavior that allows scrolling with mouse wheel
/// even when the cursor is outside the scrollable area.
class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
        PointerDeviceKind.unknown,
      };
}
