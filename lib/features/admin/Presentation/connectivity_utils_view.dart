//Connectivity test widget:
//This widget is used to test the connectivity to central services:
//  - Firebase Auth
//  - Firebase Database
//  - Firebase Storage

// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:landing_page/components/errordialog_util.dart';
import 'package:landing_page/firebase_options.dart';

class ConnectivityUtilsView extends StatelessWidget {
  const ConnectivityUtilsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connectivity Test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                await firebaseRtdbTest(context);
              },
              child: const Text('Test Firebase Database'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await firebaseAuthTest(context);
              },
              child: const Text('Test Firebase Auth'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // print('Firebase Storage Test: Not implemented');
              },
              child: const Text('Test Firebase Storage'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> firebaseRtdbTest(BuildContext context) async {
    String message = 'Firebase Database Test';
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } catch (e) {
      message = '$e.toString()';
      showErrorDialog(context, 'FirebaseRtdb :', message);
    }
    String databaseUrl = 'https://prod-firebase-rtdb.firebaseio.com/';
    final DatabaseReference databaseRef = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: databaseUrl,
    ).ref();
    try {
      await databaseRef.child('test').set('Hello World');
    } catch (e) {
      message = 'Rtbd set: $e';
      showErrorDialog(context, 'FirebaseRtdb :', message);
      return;
    }
    try {
      await databaseRef.child('test').update({'message': 'Hello World'});
    } catch (e) {
      message = 'Rtbd update: $e';
      showErrorDialog(context, 'FirebaseRtdb :', message);
      return;
    }
    try {
      await databaseRef.child('test').once();
    } catch (e) {
      message = 'Rtbd once: $e';
      showErrorDialog(context, 'FirebaseRtdb :', message);
      return;
    }
    try {
      await databaseRef.child('test').remove();
    } catch (e) {
      message = 'Rtbd remove: $e';
      showErrorDialog(context, 'FirebaseRtdb :', message);
      return;
    }
    // DatabaseEvent snapshot = await databaseReference.child('test').once();
    // print('Firebase Database Test: ${snapshot.snapshot.value}');
    if (message == 'Firebase Database Test') {
      showErrorDialog(
          context, 'FirebaseRtdb :', 'Test Firebase Database: Success');
      return;
    }
  }

  Future<void> firebaseAuthTest(BuildContext context) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: 'test.user@nodomain.com',
        password: 'veryStupidPassword',
      );
      showErrorDialog(context, 'FirebaseAuth: ', 'Test Firebase Auth: Success');
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account with this email already exist.';
      } else {
        message = '$e.toString()';
      }
      //ToDo: Update test to delete user after creation
      showErrorDialog(context, 'FirebaseAuth :', message);
    }
  }
}
