import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:landing_page/config/env.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:landing_page/features/linked-applications/domain/models/users_garmin.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:landing_page/core/resources/id_services/id_services.dart';

class ConnectedAppsPage extends StatefulWidget {
  @override
  _ConnectedAppsPageState createState() => _ConnectedAppsPageState();
}

class _ConnectedAppsPageState extends State<ConnectedAppsPage> {
  bool _isGarminConnectConnected = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GarminUser garminUser = GarminUser();

  int userIdFromJson(String str) {
    final jsonData = json.decode(str);
    return jsonData['user_id'];
  }

  Future<int> _fetchUserId() async {
    final User? user = _auth.currentUser;
    final String? firebaseUid = user?.uid;

    try {
      String idToken = await IdServices().getIdToken();
      final response = await http.get(
          Uri.parse('$mongoApiUrl/v1/users/profile/firebase_uid/$firebaseUid'),
          headers: {'Authorization': 'Bearer $idToken'});
      if (response.statusCode != 200) {
        print('Error: ${response.statusCode}');
        return 0;
      } else {
        return userIdFromJson(response.body);
      }
    } catch (e) {
      print('Error: $e');
      return 0;
    }
  }

  Future<bool> _getGarminConnectivity(int userId) async {
    try {
      String idToken = await IdServices().getIdToken();
      final response = await http.get(
          Uri.parse('$mongoApiUrl/v1/garmin/is_connected/$userId'),
          headers: {'Authorization': 'Bearer $idToken'});

      if (response.statusCode != 200) {
        print('Error: ${response.statusCode}');
        return false;
      } else {
        return await json.decode(response.body)['is_connected'];
      }
    } catch (e) {
      print('_getGarmin Error: $e');
      return false;
    }
  }

  Future<void> _connectGarminConnect() async {
    final Future<int> userId = _fetchUserId();
    String idToken = await IdServices().getIdToken();

    if (_isGarminConnectConnected) {
      await userId.then((value) async {
        // ignore: unused_local_variable
        final response = await http.get(
            Uri.parse('$mongoApiUrl/v1/garmin/disconnect/$value'),
            headers: {'Authorization': 'Bearer $idToken'});
        // print('Response: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Disconnected from Garmin Connect'),
          ),
        );
        await Future.delayed(Duration(seconds: 5));
        final int userIdValue = await userId;
        await _getGarminConnectivity(userIdValue).then((value) {
          setState(() {
            _isGarminConnectConnected = value;
          });
        });
      });
    } else {
      try {
        await userId.then((value) async {
          final response = await http.get(
              Uri.parse('$mongoApiUrl/v1/oauth/get_request_token/$value'),
              headers: {'Authorization': 'Bearer $idToken'});
          // print('Response: ${response.body}');

          if (response.statusCode == 200) {
            // Handle successful response from backend (potentially navigate or show message)
            final authorizationUrl = json.decode(response.body);
            // print(await canLaunchUrl(
            //     Uri.parse(authorizationUrl['authorization_url'])));
            if (await canLaunchUrl(
                Uri.parse(authorizationUrl['authorization_url']))) {
              await launchUrl(Uri.parse(authorizationUrl['authorization_url']));
              await Future.delayed(Duration(seconds: 10));
              final int userIdValue = await userId;
              await _getGarminConnectivity(userIdValue).then((value) {
                setState(() {
                  _isGarminConnectConnected = value;
                });
              });
            } else {
              print('Error launching authorization URL');
              // Show an error message to the user
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error connecting to Garmin'),
                ),
              );
            }
          } else {
            print('Error initiating connection: ${response.body}');
            // Show an error message to the user
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error connecting to Garmin'),
              ),
            );
          }
        });
      } on Exception catch (e) {
        print('Error during connection: $e');
        // Show a generic error message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred. Please try again later.'),
          ),
        );
      }
    }
  }

  Future<void> _initGarminConnect() async {
    _getGarminConnectivity(await _fetchUserId()).then((value) {
      setState(() {
        _isGarminConnectConnected = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _initGarminConnect();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate the width and height constraints for the cards
    final double maxCardWidth = MediaQuery.of(context).size.width / 4;
    final double maxCardHeight = MediaQuery.of(context).size.height / 4;
    final double cardWidth = maxCardWidth < 400 ? 400 : maxCardWidth;
    final double cardHeight = maxCardHeight < 250 ? 250 : maxCardHeight;
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(8.0),
        width: cardWidth,
        height: cardHeight,
        child: Card(
          elevation: 4,
          margin: EdgeInsets.all(16),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Image.asset(
                      'assets/images/garmin_connect.png',
                      width: 50,
                      height: 50,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Garmin Connect',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  'Garmin and EnduCloud work together to provide athletes with the best training experience. Connect your Garmin account to EnduCloud to sync your activities, workouts and training data.',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FutureBuilder(
                      future: _fetchUserId()
                          .then((userId) => _getGarminConnectivity(userId)),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return ElevatedButton(
                            onPressed: _connectGarminConnect,
                            child: Text('Error. Try again'),
                          );
                        } else {
                          _isGarminConnectConnected = snapshot.data ?? false;
                          return ElevatedButton(
                            onPressed: _connectGarminConnect,
                            child: Text(_isGarminConnectConnected
                                ? 'Disconnect'
                                : 'Connect'),
                          );
                        }
                      },
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
}
