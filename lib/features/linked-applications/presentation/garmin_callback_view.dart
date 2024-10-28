import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:landing_page/config/env.dart';

class GarminCallbackView extends StatefulWidget {
  final String oauthToken;
  final String oauthVerifier;

  GarminCallbackView({required this.oauthToken, required this.oauthVerifier});

  @override
  _GarminCallbackViewState createState() => _GarminCallbackViewState();
}

class _GarminCallbackViewState extends State<GarminCallbackView> {
  @override
  void initState() {
    super.initState();
    _handleGarminCallback(widget.oauthToken, widget.oauthVerifier);
  }

  Future<void> _handleGarminCallback(
      String oauthToken, String oauthVerifier) async {
    final url = Uri.parse(
        '$garminApiUrl/v1/garmin/callback?oauth_token=$oauthToken&oauth_verifier=$oauthVerifier');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      print('Handle Garmin Callback');
      print('Access Token: ${responseBody['oauth_token']}');
      print('Access Token Secret: ${responseBody['oauth_token_secret']}');
    } else {
      print('Failed to obtain access token');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Garmin Callback'),
      ),
      body: Center(
        child: Text('Handling Garmin Callback...'),
      ),
    );
  }
}
