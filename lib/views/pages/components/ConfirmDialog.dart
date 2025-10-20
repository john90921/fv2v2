import 'package:flutter/material.dart';

Future<bool?> confirmDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Confirmation'),
      content: const Text('Are you sure you want to delete this post?'),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        TextButton(
          child: const Text('Delete'),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ],
    ),
  );
}
