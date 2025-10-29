import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fv2/providers/UserProvider.dart';
import 'package:fv2/utils/message_helper.dart';
import 'package:fv2/views/pages/components/form/CustomFormField.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

class ProfileEditPage extends StatefulWidget {
  final String? name;
  final String? imageUrl;
  final String? description;
  

  const ProfileEditPage({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.description,
  });

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final _formKey = GlobalKey<FormState>();
  String? newName, newDescription;
  File? newimage;
  String? oldImagePath;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  bool IsDeletedImage = false;
  bool HaveUploadedImage = false;

    @override
  void initState() {
    super.initState();
   
      // check if editing existing post
      titleController.text = widget.name ?? ''; // set title controller text
      contentController.text = widget.description ?? ''; // set content controller text
      if (widget.imageUrl != null) {
        HaveUploadedImage = true;
      }
      oldImagePath = widget.imageUrl;
  
      super.initState();
  }
   Future pickImage(ImageSource source, BuildContext context) async {
    // Use image_picker package to pick image from gallery or camera
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() {
        oldImagePath = null;
        this.newimage = imageTemporary;
      });
    } on PlatformException catch (e) {
      print("Failed to pick image: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                   Container(
                    //image display  and  picker container
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
         
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            //title
                            "Add Image",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child:
                                  (newimage != null && newimage!.path.isNotEmpty )||
                                       (oldImagePath !=
                                          null && oldImagePath!.isNotEmpty) // check if image or the url is not null //if url have photo then show , if image file picked then show
                                  ? Stack(
                                      // show image with remove button
                                      children: [
                                        FormImage(),
                                        Positioned(
                                          right: 8,
                                          top: 8,
                                          child: CircleAvatar(
                                            // remove button
                                            backgroundColor: Colors.black54,
                                            child: IconButton(
                                              icon: const Icon(
                                                Icons.close,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  IsDeletedImage = true;
                                                  oldImagePath = null;
                                                  newimage = null;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  // Image.file(width: 200, height: 200, image!)
                                  : const Icon(
                                      Icons.image,
                                      size: 50.0,
                                      color: Colors.grey,
                                    ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [
                              TextButton.icon(
                                style: TextButton.styleFrom(
                                  backgroundColor: Color(0xFFE5E7EB),
                                ),
                                onPressed: () =>
                                    pickImage(ImageSource.camera, context),
                                icon: const Icon(Icons.camera_alt),
                                label: const Text("Camera"),
                              ),
                              SizedBox(width: 10),
                              TextButton.icon(
                                style: TextButton.styleFrom(
                                  backgroundColor: Color(0xFFE5E7EB),
                                ),
                                onPressed: () =>
                                    pickImage(ImageSource.gallery, context),
                                icon: const Icon(Icons.photo),
                                label: const Text("Gallery"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),               
                  CustomFormField(
                    controller: titleController,
                    hintText: "name",
                    minLines: 1,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter name";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      newName = value;
                    },
                  ),
                  CustomFormField(
                    controller: contentController,
                    hintText: "description",
                    minLines: 5,
                    validator: (value) {
                      return null;
                    },
                    onSaved: (value) {
                      newDescription = value;
                    },
                  ),
                  Row(
                    //button row
                    mainAxisAlignment: MainAxisAlignment.end, // align to right
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () async {
                 
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            print("Name: $newName");
                            print("Description: $newDescription");
                            print("Image: $newimage");
                            // Call provider to update profile
                          String? message =  await Provider.of<Userprovider>(context, listen: false)
                                .editProfile(
                              name: newName!,
                              description: newDescription!,
                              HaveUploadedImage: HaveUploadedImage,
                              newImagePath: newimage?.path,
                              isRemoveImage: IsDeletedImage,
                            );
                            if(context.mounted){
                            showMessage(context: context, message: message!);
                            }
                          
                            Navigator.pop(context);
                          
                          }
                        },
                        child: Text("Post"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      
      
      ),
    );
  }
  FormImage(){
    if(oldImagePath != null){ // check if old image of the post is not null then show image
       return  SizedBox(
                      width: 200,
                      height: 200,
         child: CachedNetworkImage(
                        imageUrl: oldImagePath!,
                        fit: BoxFit.fill,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.broken_image),
                      ),
       );
      // show image from url
      // return Image.network(
      //   widget.post!.image!,
      //   width: 200,
      //   height: 200,
      //   fit: BoxFit.cover,
      //   errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
      // );
    }
    return Image.file(
      newimage!,
      width: 200,
      height: 200,
      fit: BoxFit.cover,
    );
  }

  }

 