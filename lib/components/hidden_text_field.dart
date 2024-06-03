import 'package:flutter/material.dart';

class HiddenTextField extends StatefulWidget {
  final String labelText; // TextField label text
  final TextEditingController controller; // Controller for the text field
  // final Widget suffixIcon; // Define the suffixIcon field

  const HiddenTextField({
    super.key,
    required this.labelText,
    required this.controller,
    // required this.suffixIcon,
  });

  @override
  _HiddenTextFieldState createState() => _HiddenTextFieldState();
}

class _HiddenTextFieldState extends State<HiddenTextField> {
  var _obscureText = true; // Set the initial value of obscureText

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller, // Set the controller for the text field
      obscureText: _obscureText,
      // suffixIcon: widget.suffixIcon, // Use the defined suffixIcon parameter
      decoration: InputDecoration(
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText; // Toggle the value of obscureText
            });
          },
          child: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
        ),
        labelText: widget.labelText,
        labelStyle: const TextStyle(
          color: Colors.white,
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
      ),
      onFieldSubmitted: (_) {
        widget.controller.text = '${widget.controller.text}\n';
      },
    );
  }
}
