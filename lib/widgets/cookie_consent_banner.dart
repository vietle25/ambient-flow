import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_colors.dart';
import '../navigation/route_constants.dart';

/// A banner that displays cookie consent information and allows users to accept or decline.
class CookieConsentBanner extends StatefulWidget {
  const CookieConsentBanner({super.key});

  @override
  State<CookieConsentBanner> createState() => _CookieConsentBannerState();
}

class _CookieConsentBannerState extends State<CookieConsentBanner> with SingleTickerProviderStateMixin {
  static const String _prefsKey = 'cookie_consent_given';
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

    // Here you would typically implement analytics or tracking based on consent
    // For example: if (accepted) { initializeAnalytics(); }

    _animationController.reverse().then((_) {
      setState(() {
        _showBanner = false;
      });
    });
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
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final bool isNarrow = constraints.maxWidth < 600;

              return isNarrow
                  ? _buildMobileLayout()
                  : _buildDesktopLayout();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.white, fontSize: 14),
              children: [
                const TextSpan(
                  text: 'This website uses cookies to enhance your browsing experience. '
                  'By continuing to use our site, you consent to our use of cookies in accordance with our ',
                ),
                WidgetSpan(
                  child: GestureDetector(
                    onTap: () => context.router.navigateNamed(RouteConstants.cookiePolicy),
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
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.white, fontSize: 14),
            children: [
              const TextSpan(
                text: 'This website uses cookies to enhance your browsing experience. '
                'By continuing to use our site, you consent to our use of cookies in accordance with our ',
              ),
              WidgetSpan(
                child: GestureDetector(
                  onTap: () => context.router.navigateNamed(RouteConstants.cookiePolicy),
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
          children: [
            _buildButtons(),
          ],
        ),
      ],
    );
  }

  Widget _buildButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
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
