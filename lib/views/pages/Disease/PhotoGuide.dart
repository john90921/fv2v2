import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fv2/models/Post.dart';
import 'package:fv2/providers/PostProvider.dart';
import 'package:fv2/utils/message_helper.dart';
import 'package:fv2/views/pages/Disease/PhotoConfirm.dart';
import 'package:fv2/views/pages/components/form/CustomFormField.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class Photoguide extends StatefulWidget {
  const Photoguide({super.key});

  @override
  State<Photoguide> createState() => _PhotoguideState();
}

class _PhotoguideState extends State<Photoguide> {
  File? newimage;
  Future pickImage(ImageSource source, BuildContext context) async {
    // Use image_picker package to pick image from gallery or camera
    try {
      context.loaderOverlay.show();
      final image = await ImagePicker().pickImage(source: source);
      context.loaderOverlay.hide();
      if (image == null) return;
      final imageTemporary = File(image!.path);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PhotoConfirm(newImage: imageTemporary),
        ),
      );

    } on PlatformException catch (e) {
      print("Failed to pick image: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Photo Guide'), centerTitle: true),
      body:  SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child:
               Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListTile(
                    leading: Text("1"),
                    title: Text('Position the Plant'),
                    subtitle: Text(' Center the diseased parts of a leaf'),
                  ),
                  ListTile(
                    leading: Text("2"),
                    title: Text('Ensure Good Lighting'),
                    subtitle: Text(
                      'Avoid shadows and use natural light when possible',
                    ),
                  ),
                  ListTile(
                    leading: Text("3"),
                    title: Text("Keep Steady"),
                    subtitle: Text('Hold your phone still to capture a clear image'),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: TextButton.icon(
                                        style: TextButton.styleFrom(
                                          backgroundColor: Color(0xFFE5E7EB),
                                        ),
                                        onPressed: () =>
                                            pickImage(ImageSource.camera, context),
                                        icon: const Icon(Icons.camera_alt),
                                        label: const Text("Camera"),
                                      ),
                  ),
                ],
              ),
            ),
          ),
        
      
    );
  }
}
