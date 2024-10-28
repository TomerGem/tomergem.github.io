import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:landing_page/config/env.dart';
import 'package:landing_page/core/resources/id_services/id_services.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final _formKey = GlobalKey<FormState>();
  ImageProvider? _profileImage;
  XFile? _pickedImage;
  final picker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? firebaseUid;
  int? userId;
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  // Controllers for form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  String _gender = 'Select Gender';

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    User? user = _auth.currentUser;
    setState(() {
      firebaseUid = user?.uid;
      _emailController.text = user?.email ?? '';
      _phoneController.text = user?.phoneNumber ?? '';
      // Fetch user profile by firebase_uid and set userId
      _fetchUserProfile();
    });
  }

  Future<void> _fetchUserProfile() async {
    // Fetch user profile by firebase_uid
    String idToken = await IdServices().getIdToken();
    final response = await http.get(
        Uri.parse('$mongoApiUrl/v1/users/profile/firebase_uid/$firebaseUid'),
        headers: {'Authorization': 'Bearer $idToken'});
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        userId = data['user_id'];
        _nameController.text = data['profile']['name'];
        _emailController.text = data['profile']['email'];
        _phoneController.text = data['profile']['phone'];
        _locationController.text = data['profile']['location'];
        _dobController.text = data['profile']['dateOfBirth'];
        _gender = data['profile']['gender'];
        _weightController.text = data['profile']['weight'].toString();
        _heightController.text = data['profile']['height'].toString();
        _profileImage = base64ImageProvider(data['profile']['profilePicture']);
      });
    } else if (response.statusCode == 404) {
      // Create a new user if not found
      _createNewUser();
    } else {
      // Handle other errors
      print('Failed to fetch profile');
    }
  }

  Future<void> _createNewUser() async {
    // Create a new user with empty fields
    String idToken = await IdServices().getIdToken();
    final response = await http.post(
      Uri.parse('$mongoApiUrl/v1/users/profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken'
      },
      body: json.encode({
        'profile': {
          'profilePicture': '',
          'name': '',
          'email': '',
          'phone': '',
          'location': '',
          'dateOfBirth': '',
          'gender': '',
          'weight': 0,
          'height': 0,
        },
        'links': {
          'firebase_uid': firebaseUid,
        },
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        userId = data['user_id'];
      });
      print('New user created successfully');
    } else {
      print('Failed to create new user');
    }
  }

  Future<void> getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _pickedImage = pickedFile;
        _profileImage = FileImage(File(pickedFile.path));
      }
    });
  }

  Future<void> removeImage() async {
    setState(() {
      _pickedImage = null;
      _profileImage = null;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    if (_dobController.text.isNotEmpty) {
      try {
        initialDate = _dateFormat.parseStrict(_dobController.text);
      } catch (e) {
        // Keep the initial date as DateTime.now()
      }
    }

    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      setState(() {
        _dobController.text = _dateFormat.format(selectedDate);
      });
    }
  }

  Future<void> saveProfile() async {
    if (_formKey.currentState!.validate()) {
      // Update the user's display name and email in Firebase Auth
      User? user = _auth.currentUser;
      if (user != null) {
        await user.updateDisplayName(_nameController.text);
        await user.reload();
        user = _auth.currentUser;
      }

      // Encode profile image to base64
      String? profileImageBase64;
      if (_pickedImage != null) {
        final bytes = await File(_pickedImage!.path).readAsBytes();
        profileImageBase64 = base64Encode(bytes);
      } else if (_profileImage is MemoryImage) {
        // If _profileImage is already a MemoryImage, use its bytes
        final bytes = (_profileImage as MemoryImage).bytes;
        profileImageBase64 = base64Encode(bytes);
      }

      // Create request body
      Map<String, dynamic> requestBody = {
        'user_id': userId,
        'profile': {
          'profilePicture': profileImageBase64,
          'name': _nameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
          'location': _locationController.text,
          'dateOfBirth': _dobController.text,
          'gender': _gender,
          'weight': double.parse(_weightController.text),
          'height': double.parse(_heightController.text),
        },
        'links': {
          'firebase_uid': firebaseUid,
        },
      };

      // Send request to the server
      String idToken = await IdServices().getIdToken();
      final response = await http.post(
        Uri.parse('$mongoApiUrl/v1/users/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken'
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.containsKey('user_id')) {
          setState(() {
            userId = data['user_id'];
          });
        }
        print('Profile saved successfully');
      } else {
        print('Failed to save profile');
      }
      if (GoRouter.of(context).canPop()) {
        GoRouter.of(context).pop();
      }
      ;
    }
  }

  ImageProvider? base64ImageProvider(String? base64String) {
    if (base64String == null || base64String.isEmpty) return null;
    Uint8List bytes = base64Decode(base64String);
    return MemoryImage(bytes);
  }

  String? _validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter a valid date';
    }

    try {
      DateTime date = _dateFormat.parseStrict(value);
      if (date.isAfter(DateTime.now()) || date.isBefore(DateTime(1900))) {
        return 'Enter a date between 01/01/1900 and today';
      }
      return null;
    } catch (e) {
      return 'Enter a valid date';
    }
  }

  String? _validateHeight(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter a valid height';
    }

    try {
      double height = double.parse(value);
      if (height < 100 || height > 250) {
        return 'Enter a height between 100 cm and 250 cm';
      }
      return null;
    } catch (e) {
      return 'Enter a valid height';
    }
  }

  String? _validateWeight(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter a valid weight';
    }

    try {
      double weight = double.parse(value);
      if (weight < 20 || weight > 200) {
        return 'Enter a weight between 20 kg and 200 kg';
      }
      return null;
    } catch (e) {
      return 'Enter a valid weight';
    }
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }

    final phoneExp = RegExp(r'^\+?[0-9]*$');
    if (!phoneExp.hasMatch(value)) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  String? _validateTextField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please enter your $fieldName';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final double formWidth = MediaQuery.of(context).size.width * 2 / 3 > 350
        ? 350
        : MediaQuery.of(context).size.width * 2 / 3;

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Update Profile'),
      // ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: formWidth,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: getImage,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey[300],
                          backgroundImage: _profileImage,
                          child: _profileImage == null
                              ? Icon(
                                  Icons.camera_alt,
                                  color: Colors.grey[800],
                                )
                              : null,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: removeImage,
                      child: Text('Remove Image'),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Name *',
                      ),
                      validator: (value) => _validateTextField(value, 'name'),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email *',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      enabled: false, // Disable email editing
                      validator: (value) => _validateTextField(value, 'email'),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: 'Phone *',
                      ),
                      keyboardType: TextInputType.phone,
                      validator: _validatePhone,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        labelText: 'Location *',
                      ),
                      validator: (value) =>
                          _validateTextField(value, 'location'),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _dobController,
                      decoration: InputDecoration(
                        labelText: 'Date of Birth *',
                        hintText: 'dd/mm/yyyy',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () => _selectDate(context),
                        ),
                      ),
                      keyboardType: TextInputType.datetime,
                      inputFormatters: [
                        DateTextInputFormatter(),
                      ],
                      validator: _validateDate,
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: _gender,
                      decoration: InputDecoration(
                        labelText: 'Gender *',
                      ),
                      items: <String>[
                        'Select Gender',
                        'Male',
                        'Female',
                        'Other'
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _gender = newValue!;
                        });
                      },
                      validator: (value) {
                        if (value == 'Select Gender') {
                          return 'Please select your gender';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _weightController,
                      decoration: InputDecoration(
                        labelText: 'Weight (kg) *',
                      ),
                      keyboardType: TextInputType.number,
                      validator: _validateWeight,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _heightController,
                      decoration: InputDecoration(
                        labelText: 'Height (cm) *',
                      ),
                      keyboardType: TextInputType.number,
                      validator: _validateHeight,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: saveProfile,
                      child: Text('Save'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DateTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;

    if (text.length == 2 && oldValue.text.length < text.length) {
      text += '/';
    } else if (text.length == 5 && oldValue.text.length < text.length) {
      text += '/';
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
