import 'package:flutter/material.dart';

/// Shows a reusable message (success or error) in a SnackBar.
/// [message] is the text to display.
/// [isError] = true shows it in red, otherwise green.
void showMessage(
 {required BuildContext context,
  required String message, 
  bool isError = false,
}) {
  // Remove any existing snackbar before showing a new one
if(!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: isError ? Colors.red : Colors.green,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(12),
      duration: const Duration(seconds: 3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}
