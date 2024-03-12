import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/widgets/custom_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});
  TextSpan getSection({required String title, required String content}) {
    return TextSpan(
      children: [
        TextSpan(
          text: '\n\n$title\n',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
          ),
        ),
        TextSpan(
          text: content,
          style: const TextStyle(
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          onTap: () {
            context.pop();
          },
          title: AppLocalizations.of(context)!.privacyText),
      body: Padding(
        padding:
            const EdgeInsets.only(bottom: 20, left: 20, right: 20, top: 10),
        child: SingleChildScrollView(
          child: RichText(
            key: const Key('privacy_rich_text'),
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.start,
            text: TextSpan(
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
              children: [
                const TextSpan(
                  text:
                      'Thank you for using the Rate Eat mobile application (the "App"). This Privacy Policy outlines how we collect, use, disclose, and safeguard your personal information when you use our App. By downloading, installing, or using the App, you agree to the terms and practices described in this Privacy Policy.',
                ),
                getSection(
                  title: "1. Information We Collect",
                  content:
                      '''1.1 Personal Information\nWe may collect personal information that you provide when using the App, including but not limited to your name, email address, and location information. This information is collected for the purpose of providing you with a personalized and enhanced experience.\n\n1.2 Location Information\nWe may collect personal information that you provide when using the App, including but not limited to your name, email address, and location information. This information is collected for the purpose of providing you with a personalized and enhanced experience.''',
                ),
                getSection(
                  title: "2.  How We Use Your Information",
                  content: '''2.1 Personalization
We use the information collected to personalize your experience with the App, including providing location-based content and improving our services.

2.2 Communication
We may use your email address to communicate with you regarding important updates, announcements, and other information related to the App.

2.3 Analytics
We may use analytics tools to collect and analyze non-personal information about how users interact with the App. This information helps us improve the App's functionality and user experience.''',
                ),
                getSection(title: '3. Information Sharing', content: '''
We do not sell, trade, or otherwise transfer your personal information to third parties without your consent, except as described in this Privacy Policy. We may share your information with trusted third-party service providers who assist us in operating the App and providing services.'''),
                getSection(title: "4. Security", content: '''
We take reasonable measures to protect the security of your personal information. However, no method of transmission over the internet or electronic storage is completely secure, and we cannot guarantee absolute security.'''),
                getSection(title: "5. Changes to Privacy Policy", content: '''
We reserve the right to update or modify this Privacy Policy at any time. Any changes will be effective immediately upon posting the revised Privacy Policy. We encourage you to review this Privacy Policy regularly for updates.'''),
                getSection(
                    title: "6. Contact Us",
                    content:
                        "If you have any questions or concerns about this Privacy Policy or the privacy practices of the App, please contact us at\n"),
                TextSpan(
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily:
                        'poppins', // Replace with your desired font family
                    fontWeight: FontWeight.normal,
                  ),
                  children: [
                    _buildEmailLinkSpan('contact-rateeat@a2sv.org', context),
                    const TextSpan(
                      text:
                          '''\nBy using the Rate Eat mobile application, you acknowledge that you have read, understood, and agree to be bound by this Privacy Policy.
    ''',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextSpan _buildEmailLinkSpan(String email, BuildContext context) {
    return TextSpan(
      text: email,
      style: const TextStyle(
        color: Colors.blue,
        decoration: TextDecoration.underline,
      ),
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          _launchEmailApp(email);
        },
    );
  }

  Future<void> _launchEmailApp(String email) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
    );

    if (await canLaunchUrl(Uri.parse(emailLaunchUri.toString()))) {
      await launchUrl(Uri.parse(emailLaunchUri.toString()));
    } else {
      throw 'Could not launch $email';
    }
  }
}
