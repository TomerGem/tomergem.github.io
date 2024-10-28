import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CookiesWarning extends StatelessWidget {
  final VoidCallback onClose;

  CookiesWarning({required this.onClose});

  @override
  Widget build(BuildContext context) {
    const privacyUrl = 'https://enducloud.com/legal/privacy.html';

    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.grey[200],
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.grey[600]),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'This website uses cookies to ensure you get the best experience. By continuing to use this site, you agree to our privacy policy.',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          SizedBox(width: 8),
          TextButton(
            onPressed: () {
              _launchURL(privacyUrl);
            },
            child: Text(
              'Learn More',
            ),
          ),
          SizedBox(width: 8),
          IconButton(
            // onPressed: () {},
            onPressed: onClose,
            icon: Icon(Icons.close, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}

Future<void> _launchURL(String url) async {
  await canLaunchUrl(Uri.parse(url))
      ? await launchUrl(Uri.parse(url))
      : throw 'Could not launch $url';
}
