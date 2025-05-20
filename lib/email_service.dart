import 'package:url_launcher/url_launcher.dart';

class EmailService {
  Future<void> sendEmail({required String to, required String subject, required String body}) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: to,
      queryParameters: {
        'subject': subject,
        'body': body,
      },
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Sähköpostin avaaminen epäonnistui';
    }
  }
}

