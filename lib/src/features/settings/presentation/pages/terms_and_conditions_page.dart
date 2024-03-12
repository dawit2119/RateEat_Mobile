import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/widgets/custom_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

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
          title: AppLocalizations.of(context)!.termsText),
      body: Padding(
        padding:
            const EdgeInsets.only(bottom: 20, left: 20, right: 20, top: 10),
        child: SingleChildScrollView(
          child: RichText(
            key: const Key('terms_and_conditions_rich_text'),
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
                      'Welcome to RatEat! These Terms and Conditions ("Terms") govern your access to and use of the RateEat mobile application (the "App"), including any content, functionality, and services offered through the App.',
                ),
                getSection(
                    title: "1. Acceptance of Terms",
                    content:
                        '''By downloading, installing, or using the App, you agree to be bound by these Terms. If you do not agree to these Terms, please do not use the App.'''),
                getSection(
                    title: "2. Use of the App",
                    content:
                        '''(a) You must be at least 18 years old to use the App. By using the App, you represent and warrant that you are at least 18 years old.
\n(b) You agree to provide accurate, current, and complete information during the registration process and to update such information to keep it accurate, current, and complete.
\n(c) You are responsible for maintaining the confidentiality of your account and password and for restricting access to your mobile device. You agree to accept responsibility for all activities that occur under your account or password.'''),
//3
                getSection(
                    title: "3. Location Services",
                    content:
                        '''(a) The App uses location services to provide you with relevant content based on your geographical location.
\n(b) You grant RateEat permission to access and use your location information to enhance your experience with the App.
\n(c) You may disable location services through your mobile device settings, but this may limit certain features of the App.'''),

                //4
                getSection(
                    title: "4. User Content",
                    content:
                        '''You may submit reviews, ratings, and other content through the App ("User Content"). By submitting User Content, you grant RateEat a non-exclusive, royalty-free, worldwide, perpetual, and irrevocable right to use, reproduce, modify, adapt, publish, distribute, and display such User Content.

(b) You represent and warrant that your User Content is accurate, not misleading, and does not violate any third-party rights.

(c) Rate Eat reserves the right to remove or modify User Content for any reason, including if it violates these Terms or is deemed inappropriate.'''),
                //5
                getSection(
                    title: "5. Intellectual Property",
                    content:
                        '''The App and its content are owned by [Your Company Name] and are protected by intellectual property laws. You may not use, reproduce, distribute, or create derivative works based on the App or its content without the express written consent of [Your Company Name].'''),
                //6
                getSection(
                    title: "6. Terminations",
                    content:
                        '''RateEat reserves the right to terminate or suspend your account and access to the App at its sole discretion, without notice, for any reason, including if you violate these Terms.'''),
                //7
                getSection(
                    title: "7. Privacy",
                    content:
                        '''Your use of the App is also governed by our Privacy Policy, which can be found [link to privacy policy]. By using the App, you consent to the collection, use, and sharing of information as described in the Privacy Policy.'''),
                //8
                getSection(
                    title: "8. Disclaimer of Warranties",
                    content:
                        '''The App is provided "as is" and "as available" without any warranties, express or implied. Rate Eat does not warrant that the App will be error-free or uninterrupted.'''),
                //9
                getSection(
                    title: "9. Limitation of Liability",
                    content:
                        '''To the fullest extent permitted by law, Rate Eat shall not be liable for any indirect, incidental, special, consequential, or punitive damages, or any loss of profits or revenues, whether incurred directly or indirectly, or any loss of data, use, goodwill, or other intangible losses.'''),

                //10
                getSection(
                    title: "10. Governing Law",
                    content:
                        '''These Terms are governed by and construed in accordance with the laws of [Your Jurisdiction], without regard to its conflict of law principles.'''),

                TextSpan(
                  text: '''Contact Information:
If you have any questions about these Terms, please contact us at\n''',
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily:
                        'poppins', // Replace with your desired font family
                    fontWeight: FontWeight.normal,
                  ),
                  children: [
                    _buildEmailLinkSpan('contact-rateeat@a2sv.org'),
                    const TextSpan(text: '''\n
By using the App, you acknowledge that you have read, understood, and agree to be bound by these Terms and Conditions.''')
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextSpan _buildEmailLinkSpan(String email) {
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
