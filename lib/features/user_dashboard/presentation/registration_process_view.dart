import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:landing_page/features/user_dashboard/presentation/user_profile_page_widget.dart';
import 'package:landing_page/features/user_dashboard/presentation/user_preferences_page.dart'; // Correct import

class RegistrationProcessView extends StatefulWidget {
  @override
  _RegistrationProcessViewState createState() =>
      _RegistrationProcessViewState();
}

class _RegistrationProcessViewState extends State<RegistrationProcessView> {
  int _currentStep = 0;
  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  void _nextStep() {
    if (_formKeys[_currentStep].currentState!.validate()) {
      if (_currentStep < _formKeys.length - 1) {
        setState(() {
          _currentStep++;
        });
      } else {
        // Complete the registration and navigate to the dashboard
        context.go('/dashboard');
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  void _completeRegistration() {
    if (_formKeys[_currentStep].currentState!.validate()) {
      // Complete the registration process
      context.go('/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    double availableHeight = MediaQuery.of(context).size.height -
        kToolbarHeight -
        AppBar().preferredSize.height -
        100;

    return Scaffold(
      appBar: AppBar(
        title: Text('Registration Process'),
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: _nextStep,
        onStepCancel: _previousStep,
        steps: [
          Step(
            title: Text('User Profile'),
            content: Container(
              height: availableHeight,
              child: Form(
                key: _formKeys[0],
                child: UserProfilePage(),
              ),
            ),
            isActive: _currentStep >= 0,
          ),
          Step(
            title: Text('User Preferences'),
            content: Container(
              height: availableHeight,
              child: Form(
                key: _formKeys[1],
                child: UserPreferencesPage(),
              ),
            ),
            isActive: _currentStep >= 1,
          ),
        ],
        controlsBuilder: (BuildContext context, ControlsDetails details) {
          return Row(
            children: <Widget>[
              if (_currentStep != 0)
                ElevatedButton(
                  onPressed: details.onStepCancel,
                  child: const Text('Back'),
                ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _currentStep < _formKeys.length - 1
                    ? details.onStepContinue
                    : _completeRegistration,
                child: const Text('Next'),
              ),
            ],
          );
        },
      ),
    );
  }
}
