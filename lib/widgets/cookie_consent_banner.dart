import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_colors.dart';
import '../screens/cookie_policy/cookie_policy_page.dart';

/// A banner that displays cookie consent information and allows users to accept or decline.
class CookieConsentBanner extends StatefulWidget {
  const CookieConsentBanner({super.key});

  @override
  State<CookieConsentBanner> createState() => _CookieConsentBannerState();
}

class _CookieConsentBannerState extends State<CookieConsentBanner>
    with SingleTickerProviderStateMixin {
  static const String _prefsKey = 'cookie_consent_given';
  static const String _analyticsPrefsKey = 'analytics_cookies_consent';
  static const String _functionalPrefsKey = 'functional_cookies_consent';
  bool _showBanner = false;
  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _checkConsentStatus();
  }

  Future<void> _checkConsentStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool consentGiven = prefs.getBool(_prefsKey) ?? false;

    // Debug: Print consent status
    print('Cookie consent status: $consentGiven');

    if (!consentGiven) {
      setState(() {
        _showBanner = true;
      });
      _animationController.forward();
    }
  }

  Future<void> _setConsentStatus(bool accepted) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsKey, true);

    if (accepted) {
      // Accept all cookies
      await prefs.setBool(_analyticsPrefsKey, true);
      await prefs.setBool(_functionalPrefsKey, true);
    } else {
      // Decline non-essential cookies
      await prefs.setBool(_analyticsPrefsKey, false);
      await prefs.setBool(_functionalPrefsKey, false);
    }

    // Debug: Verify the value was saved
    final bool saved = prefs.getBool(_prefsKey) ?? false;
    print('Cookie consent saved: $saved');

    // Here you would typically implement analytics or tracking based on consent
    // For example: if (accepted) { initializeAnalytics(); }

    _animationController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _showBanner = false;
        });
      }
    });
  }

  void _openCookiePolicy() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const CookiePolicyPage(),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_showBanner) {
      return const SizedBox.shrink();
    }

    return SlideTransition(
      position: _offsetAnimation,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.primaryBackground.withOpacity(0.95),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final bool isNarrow = constraints.maxWidth < 600;

              return isNarrow ? _buildMobileLayout() : _buildDesktopLayout();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 3,
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.white, fontSize: 14),
              children: <InlineSpan>[
                const TextSpan(
                  text:
                      'This website uses cookies to enhance your browsing experience. '
                      'By continuing to use our site, you consent to our use of cookies in accordance with our ',
                ),
                WidgetSpan(
                  child: GestureDetector(
                    onTap: _openCookiePolicy,
                    child: const Text(
                      'Cookie Policy',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const TextSpan(text: '.'),
              ],
            ),
          ),
        ),
        const SizedBox(width: 24),
        _buildButtons(),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.white, fontSize: 14),
            children: <InlineSpan>[
              const TextSpan(
                text:
                    'This website uses cookies to enhance your browsing experience. '
                    'By continuing to use our site, you consent to our use of cookies in accordance with our ',
              ),
              WidgetSpan(
                child: GestureDetector(
                  onTap: _openCookiePolicy,
                  child: const Text(
                    'Cookie Policy',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const TextSpan(text: '.'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            _buildButtons(),
          ],
        ),
      ],
    );
  }

  Widget _buildButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TextButton(
          onPressed: () => _setConsentStatus(false),
          style: TextButton.styleFrom(
            foregroundColor: Colors.white70,
          ),
          child: const Text('Decline'),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () => _setConsentStatus(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AppColors.secondaryBackground,
          ),
          child: const Text('Accept'),
        ),
      ],
    );
  }
}
