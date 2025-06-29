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
          onPressed: () => context.router.maybePop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Cookie Policy',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Last updated: December 2024',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 32),
                _buildSection(
                  'What Are Cookies',
                  'Cookies are small text files that are stored on your computer or mobile device when you visit our website. They are processed and stored by your web browser and serve crucial functions for websites. Cookies can contain data that may potentially identify you, which is why they are subject to data protection regulations including the General Data Protection Regulation (GDPR) and ePrivacy Directive.',
                ),
                _buildSection(
                  'How We Use Cookies',
                  'Ambient Flow uses cookies to enhance your browsing experience and provide essential functionality. We use cookies for the following purposes:\n\n'
                      '• Essential website functionality and security\n'
                      '• Remembering your sound preferences and settings\n'
                      '• Saving your bookmark configurations\n'
                      '• Maintaining your authentication status\n'
                      '• Analyzing website performance and user interactions\n'
                      '• Improving our services based on usage patterns',
                ),
                _buildSection(
                  'Types of Cookies We Use',
                  'We categorize our cookies based on their purpose and duration:\n\n'
                      '**Essential Cookies (Strictly Necessary)**\n'
                      'These cookies are necessary for the website to function properly and cannot be disabled. They include:\n'
                      '• Authentication cookies to keep you logged in\n'
                      '• Security cookies to protect against fraud\n'
                      '• Session cookies for basic website functionality\n\n'
                      '**Preference Cookies (Functionality)**\n'
                      'These cookies remember your choices and settings:\n'
                      '• Sound volume and mix preferences\n'
                      '• Bookmark configurations\n'
                      '• Language and region preferences\n'
                      '• Theme and display settings\n\n'
                      '**Analytics Cookies (Performance)**\n'
                      'These cookies help us understand how you use our website:\n'
                      '• Page visit statistics\n'
                      '• Feature usage analytics\n'
                      '• Performance monitoring\n'
                      '• Error tracking and debugging\n\n'
                      '**Duration Categories:**\n'
                      '• Session cookies: Expire when you close your browser\n'
                      '• Persistent cookies: Remain until deleted or expired (up to 12 months)',
                ),
                _buildSection(
                  'Cookie Consent and Your Rights',
                  'Under GDPR and ePrivacy regulations, you have the following rights:\n\n'
                      '• **Consent**: We obtain your consent before using non-essential cookies\n'
                      '• **Information**: We provide clear information about each cookie\'s purpose\n'
                      '• **Control**: You can accept or decline different types of cookies\n'
                      '• **Withdrawal**: You can withdraw consent as easily as you gave it\n'
                      '• **Access**: You can access our service even if you decline certain cookies\n\n'
                      'Essential cookies do not require consent as they are necessary for the website to function.',
                ),
                _buildSection(
                  'Managing and Deleting Cookies',
                  'You can control cookies through several methods:\n\n'
                      '**Browser Settings:**\n'
                      'Most browsers allow you to:\n'
                      '• View and delete existing cookies\n'
                      '• Block cookies from specific websites\n'
                      '• Block third-party cookies\n'
                      '• Set cookies to be deleted when you close your browser\n\n'
                      '**Our Cookie Banner:**\n'
                      'When you first visit our website, you can choose which types of cookies to accept.\n\n'
                      '**Important Note:**\n'
                      'Blocking essential cookies may prevent some features of our website from working properly. Preference cookies enhance your experience but are not required for basic functionality.',
                ),
                _buildSection(
                  'Third-Party Cookies',
                  'We may use third-party services that set their own cookies:\n\n'
                      '• **Google Analytics**: For website analytics and performance monitoring\n'
                      '• **Firebase**: For authentication and data storage\n'
                      '• **Content Delivery Networks**: For faster content delivery\n\n'
                      'These third parties have their own privacy policies and cookie practices. We recommend reviewing their policies for more information about how they use cookies.',
                ),
                _buildSection(
                  'Data Protection and Security',
                  'We are committed to protecting your privacy and personal data:\n\n'
                      '• Cookie data is stored securely and encrypted where appropriate\n'
                      '• We only collect data necessary for the specified purposes\n'
                      '• Personal data in cookies is processed lawfully and transparently\n'
                      '• We implement appropriate technical and organizational measures\n'
                      '• Cookie data is retained only as long as necessary',
                ),
                _buildSection(
                  'Changes to This Cookie Policy',
                  'We may update our Cookie Policy from time to time to reflect changes in our practices, technology, or legal requirements. When we make significant changes:\n\n'
                      '• We will post the updated policy on this page\n'
                      '• We will update the "Last updated" date\n'
                      '• We may notify you through our website or other communication methods\n'
                      '• Continued use of our website after changes constitutes acceptance',
                ),
                _buildSection(
                  'Contact Us',
                  'If you have any questions about our Cookie Policy, your rights, or how we use cookies, please contact us:\n\n'
                      '**Email**: privacy@ambientflow.com\n'
                      '**Subject**: Cookie Policy Inquiry\n\n'
                      'We will respond to your inquiry within 30 days as required by GDPR regulations.',
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
        children: <Widget>[
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
