import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  const CustomFormField({super.key, required this.hintText,required this.validator, required this.onSaved, this.minLines = 1, required this.controller});
  final String hintText;
  final String? Function(String?) validator;
  final String? Function(String?) onSaved;
  final int minLines;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        TextFormField(
          keyboardType: TextInputType.multiline,
          maxLines: null, // Allows unlimited lines
          minLines: minLines, // Starts with 3 lines tall
          decoration: InputDecoration(
            labelText: hintText, 
            border: const OutlineInputBorder(),
            hintText: hintText,
          ),
          controller: controller,
          validator: validator,
          onSaved: onSaved,
        ),
         const SizedBox(height: 10)
      ],
    );
  }
}
