import 'package:flutter/material.dart';
import 'package:fv2/models/Post.dart';
import 'package:fv2/providers/PostProvider.dart';
import 'package:fv2/views/pages/components/ConfirmDialog.dart';
import 'package:fv2/views/pages/components/ShowReplyBottomSheet.dart';

Future<void> showReportsOptionSheet({
  required BuildContext context,
  // required int id,
  required Future Function() onDelete,

  required bool isFromPostPage,
  // required Future Function() onEdit
}) async {
  try {
    await showModalBottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Text(
                  "Settings",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.close), //close the setting
                  onPressed: () {
                    Navigator.pop(context);
                 
                  },
                ),
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: const Icon(Icons.report),
                title: const Text('Report'),
                subtitle: const Text('Report this post'),
                onTap: () async {
                  String message =
                      await onDelete(); // Call the passed delete function
                  Navigator.pop(context);

                  if (isFromPostPage) {
                    Navigator.pop(context);
                  }

                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text(message)));
                },
              ),
            ],
          ),
        );
      },
    );
  } catch (e) {
    print("Error showing bottom sheet: $e");
  }
}
