import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';
import 'package:go_router/go_router.dart';

class DeepLinkHandler extends StatefulWidget {
  @override
  _DeepLinkHandlerState createState() => _DeepLinkHandlerState();
}

class _DeepLinkHandlerState extends State<DeepLinkHandler> {
  @override
  void initState() {
    super.initState();
    initUniLinks();
  }

  Future<void> initUniLinks() async {
    // Handle initial deep link if app is already launched with a deep link
    try {
      final initialLink = await getInitialLink();
      if (initialLink != null) {
        _handleLink(initialLink);
      }
    } catch (e) {
      print('Failed to handle initial link: $e');
    }

    // Handle subsequent deep links using linkStream
    linkStream.listen((String? link) {
      if (link != null) {
        _handleLink(link);
      }
    }, onError: (err) {
      print('Failed to handle link stream: $err');
    });
  }

  void _handleLink(String link) {
    final uri = Uri.parse(link);
    final oauthToken = uri.queryParameters['oauth_token'];
    final oauthVerifier = uri.queryParameters['oauth_verifier'];

    if (oauthToken != null && oauthVerifier != null) {
      // Navigate to GarminCallbackView and pass parameters as a map
      context.go('/callback', extra: {
        'oauth_token': oauthToken,
        'oauth_verifier': oauthVerifier,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
