import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

@RoutePage()
class CookiePolicyPage extends StatelessWidget {
  const CookiePolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cookie Policy'),
        backgroundColor: AppColors.primaryBackground.withOpacity(0.8),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.router.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Cookie Policy',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Last updated: June 2024',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 32),
                _buildSection(
                  'What Are Cookies',
                  'Cookies are small text files that are stored on your computer or mobile device when you visit a website. They are widely used to make websites work more efficiently and provide information to the website owners.',
                ),
                _buildSection(
                  'How We Use Cookies',
                  'We use cookies for several purposes, including:\n\n'
                  '• To provide essential website functionality\n'
                  '• To remember your preferences\n'
                  '• To analyze how you use our website\n'
                  '• To personalize your experience\n'
                  '• To improve our website based on your behavior',
                ),
                _buildSection(
                  'Types of Cookies We Use',
                  '1. Essential Cookies: These are necessary for the website to function properly.\n\n'
                  '2. Preference Cookies: These remember your settings and preferences.\n\n'
                  '3. Analytics Cookies: These help us understand how visitors interact with our website.\n\n'
                  '4. Marketing Cookies: These track your activity to deliver personalized ads.',
                ),
                _buildSection(
                  'Managing Cookies',
                  'You can control and manage cookies in various ways. You can modify your browser settings to reject or delete cookies. Please note that if you choose to block cookies, some features of our website may not function properly.',
                ),
                _buildSection(
                  'Changes to This Cookie Policy',
                  'We may update our Cookie Policy from time to time. We will notify you of any changes by posting the new Cookie Policy on this page.',
                ),
                _buildSection(
                  'Contact Us',
                  'If you have any questions about our Cookie Policy, please contact us at:\n\n'
                  'Email: privacy@ambientflow.com',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
