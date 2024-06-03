import 'package:flutter/material.dart';

class StandardTextField extends StatelessWidget {
  final String labelText; // TextField label text
  final TextEditingController controller; // Controller for the text field

  const StandardTextField({
    super.key,
    required this.labelText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller, // Set the controller for the text field
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: labelText,
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
        controller.text = '${controller.text}\n';
      },
    );
  }
}
