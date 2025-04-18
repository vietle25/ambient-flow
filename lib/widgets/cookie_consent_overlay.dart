import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'cookie_consent_banner.dart';

/// A builder widget that adds the cookie consent banner as an overlay
/// to the app when running on the web platform.
class CookieConsentOverlay extends StatelessWidget {
  final Widget child;

  const CookieConsentOverlay({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Only add the overlay on web platforms
    if (!kIsWeb) {
      return child;
    }

    return Stack(
      children: [
        // The main app content
        child,
        
        // Cookie consent banner
        const CookieConsentBanner(),
      ],
    );
  }
}
