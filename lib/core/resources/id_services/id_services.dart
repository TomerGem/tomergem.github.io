import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:landing_page/config/env.dart';

class IdServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> getUserId() async {
    final User? user = _auth.currentUser;
    final String? firebaseUid = user?.uid;
    return firebaseUid!;
  }

  Future<String> getIdToken() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        String? idToken = await user.getIdToken(true); // Force refresh
        if (idToken != null) {
          return idToken;
        } else {
          throw Exception("Failed to get ID token");
        }
      } on FirebaseAuthException catch (e) {
        // Handle specific FirebaseAuth errors (e.g., token expired)
        throw Exception("Error getting ID token: ${e.message}");
      } catch (e) {
        // Handle other exceptions
        throw Exception("Failed to get ID token: ${e.toString()}");
      }
    } else {
      throw Exception("User not authenticated");
    }
  }

  Future<int> user_id() async {
    final User? user = _auth.currentUser;
    final String? firebaseUid = user?.uid;

    try {
      String idToken = await getIdToken();
      final response = await http.get(
          Uri.parse('$mongoApiUrl/v1/users/profile/firebase_uid/$firebaseUid'),
          headers: {'Authorization': 'Bearer $idToken'});
      if (response.statusCode != 200) {
        print('Error: ${response.statusCode}');
        return 0;
      } else {
        return json.decode(response.body)['user_id'];
      }
    } catch (e) {
      print('Error: $e');
      return 0;
    }
  }
}
