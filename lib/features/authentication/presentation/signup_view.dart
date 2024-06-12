// import 'dart:math';
import 'package:email_validator/email_validator.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter_email_sender/flutter_email_sender.dart';
// import 'package:landing_page/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:landing_page/components/email_field.dart';
// import 'package:landing_page/components/errordialog_util.dart';
import 'package:landing_page/components/password_field.dart';
// import 'package:landing_page/components/snackbar_util.dart';
import 'package:landing_page/features/authentication/domain/auth_service.dart';
// import 'package:landing_page/features/authentication/domain/invitation_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:landing_page/features/authentication/presentation/providers/auth_state_provider.dart';
import 'package:landing_page/utilities/firebase_list_util.dart';
import 'package:cloud_functions/cloud_functions.dart';

class SignupView extends ConsumerStatefulWidget {
  const SignupView({Key? key});

  @override
  // ignore: library_private_types_in_public_api
  _SignupViewState createState() => _SignupViewState();
}

class _SignupViewState extends ConsumerState<SignupView> {
  final passwordController = TextEditingController();
  static const String logoAssetPath = 'assets/images/enducloud_logo_s.png';
  // static const String databaseUrl =
  //     'https://prod-firebase-rtdb.firebaseio.com/';
  final DatabaseService _dbService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Center(
        child: Container(
          width: 500, // Adjust the width as needed
          height: 350, // Adjust the height as needed
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(8),
              color: Colors.indigo[800]),
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      logoAssetPath,
                      height: 50,
                      width: 50,
                    ),
                    const Text(
                      'Create \r\nnew account',
                      style: TextStyle(fontSize: 30),
                    ),
                    const Text(
                      'Initial information',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    EmailField(),
                    const SizedBox(height: 16),
                    const PasswordField(),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/login');
                          },
                          child: const Text(
                            'Already \r\na member?',
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            String email =
                                ref.read(emailProvider.notifier).state;
                            String password =
                                ref.read(passwordProvider.notifier).state;

                            if (!EmailValidator.validate(email)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Invalid email format.'),
                                ),
                              );
                              return;
                            }

                            try {
                              List<String> emails = await _dbService
                                  .fetchItems('invitation-list');
                              if (emails.contains(email)) {
                                await AuthService().signupWithEmailAndPassword(
                                  context: context,
                                  email: email,
                                  password: password,
                                );
                              } else {
                                addToWaitingListDialog(context, email);
                              }
                            } catch (error) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Error'),
                                    content: Text(
                                        'Error fetching waitingList: $error'),
                                    actions: [
                                      TextButton(
                                        child: const Text('OK'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          //Todo: Add you can add your email to the waiting list here
                          //ToDo: disable the button if the email is not valid
                          //ToDo: disable the button if the password is not valid
                          //ToDo: Check if ;email is in the invite list

                          child: const Text('Next'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addToWaitingListDialog(BuildContext context, String email) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Email is not in the invitation list'),
          content: Text('You can add your email to the waiting list.'),
          actions: [
            TextButton(
              child: const Text('Add'),
              onPressed: () async {
                try {
                  List<String> waitingListItems =
                      await _dbService.fetchItems('waiting-list');

                  if (waitingListItems.contains(email)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Email already in the waiting list.'),
                      ),
                    );
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, '/login');
                  } else {
                    await _dbService.addItemToList('waiting-list', email);
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Email added to waiting list.'),
                      ),
                    );
                    sendConfirmationEmail(email);

                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, '/login');
                  }
                } catch (error) {
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content: Text('Error adding to waiting list: $error'),
                        actions: [
                          TextButton(
                            child: const Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> sendConfirmationEmail(String email) async {
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('sendConfirmationEmail');
      final response = await callable.call(<String, dynamic>{
        'email': email,
      });
      if (response.data['success']) {
        print('Confirmation email sent to $email');
      } else {
        print('Error sending confirmation email: ${response.data['error']}');
      }
    } catch (error) {
      print('Error sending confirmation email: $error');
    }
  }
}
