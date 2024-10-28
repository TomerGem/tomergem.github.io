import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GarminRegistrationView extends StatefulWidget {
  @override
  _GarminRegistrationViewState createState() => _GarminRegistrationViewState();
}

class _GarminRegistrationViewState extends State<GarminRegistrationView> {
  final String clientId = 'your_client_id';
  final String redirectUri = 'your_redirect_uri';
  final String authorizationEndpoint =
      'https://connect.garmin.com/oauth/authorize';
  final FlutterWebviewPlugin flutterWebviewPlugin = FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();
    flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (url.startsWith(redirectUri)) {
        _handleAuthResponse(url);
      }
    });
  }

  void _handleAuthResponse(String url) async {
    Uri uri = Uri.parse(url);
    String? code = uri.queryParameters['code'];

    if (code != null) {
      // Save the authorization code in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_code', code);
      // Close the webview
      flutterWebviewPlugin.close();
      Navigator.pop(context);
    } else {
      // Handle the error: authorization code not found
      print('Error: Authorization code not found.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url:
          '$authorizationEndpoint?client_id=$clientId&response_type=code&redirect_uri=$redirectUri',
      appBar: AppBar(
        title: Text('Garmin Registration'),
      ),
    );
  }
}
