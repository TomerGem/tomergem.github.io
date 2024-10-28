import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:landing_page/components/snackbar_util.dart';

class AuthService {
  Future<bool> signupWithEmailAndPassword({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account with this email already exist.';
      }

      // ignore: use_build_context_synchronously
      showSnackbar(context, message);
      return false;
    } catch (e) {
      String message = 'An error occurred';
      // ToDo: Add error handling
      showSnackbar(context, message);
      return false;
    }
    return true;
  }

  Future<bool> loginWithEmailAndPassword({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    String message = 'Login successful!';

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
      }

      // ignore: use_build_context_synchronously
      showSnackbar(context, message);
      return false;
    } catch (e) {
      message = 'Login Error. Please try again later.';
      showSnackbar(context, message);
      return false;
    }
    return true;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
