import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fv2/models/Post.dart';
import 'package:fv2/providers/PostProvider.dart';
import 'package:fv2/utils/message_helper.dart';
import 'package:fv2/views/pages/components/form/CustomFormField.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

class PostFormPage extends StatefulWidget {
  final Post? post;
  const PostFormPage({super.key, this.post});

  @override
  State<PostFormPage> createState() => _PostFormPageState();
}

class _PostFormPageState extends State<PostFormPage> {
  final _formKey = GlobalKey<FormState>();
  String? newtitle, newcontent;
  File? newimage;
  String? oldImagePath;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  bool IsDeletedImage = false;
  bool HaveUploadedImage = false;

  @override
  void initState() {
    super.initState();
    if (widget.post != null) {
      // check if editing existing post
      titleController.text = widget.post!.title; // set title controller text
      contentController.text =
          widget.post!.content; // set content controller text
      if (widget.post!.image != null) {
        HaveUploadedImage = true;
      }
      oldImagePath = widget.post!.image;
    }
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  Future pickImage(ImageSource source, BuildContext context) async {
    // Use image_picker package to pick image from gallery or camera
    try {
      context.loaderOverlay.show();
      final image = await ImagePicker().pickImage(source: source);
      context.loaderOverlay.hide();
      if (image == null) return;
      final imageTemporary = File(image!.path);
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
        title: Text(widget.post != null ? "Edit Post" : "New Post"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
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
                            print(
                              "Title: $newtitle, Content: $newcontent, Image: $newimage.path",
                            );
                            String? result;
                            try {
                              context.loaderOverlay.show();
                              if (widget.post != null) {
                                // editing existing post
                                result =
                                    await Provider.of<PostProvider>(
                                      context,
                                      listen: false,
                                    ).editPost(
                                      post: widget.post!,
                                      title: newtitle!,
                                      content: newcontent!,
                                      isRemoveImage : IsDeletedImage,
                                      HaveUploadedImage : HaveUploadedImage,
                                      newImagePath: newimage?.path,
                                    );
                              } else {
                                result =
                                    await Provider.of<PostProvider>(
                                      context,
                                      listen: false,
                                    ).addNewPost(
                                      newtitle!,
                                      newcontent!,
                                      newimage?.path,
                                      context,
                                    );
                              }
                            } on Exception catch (e) {
                              result = e.toString();
                            }
                            context.loaderOverlay.hide();
                            if (result != null) {
                              showMessage(context: context, message: result);
                            }
                  
                            Navigator.pop(context);
                          }
                        },
                        child: Text("Post"),
                      ),
                    ],
                  ),
                  CustomFormField(
                    controller: titleController,
                    hintText: "Title",
                    minLines: 1,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter title";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      newtitle = value;
                    },
                  ),
                  CustomFormField(
                    controller: contentController,
                    hintText: "Content",
                    minLines: 5,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter content";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      newcontent = value;
                    },
                  ),
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
                                  newimage != null ||
                                       oldImagePath !=
                                          null // check if image or the url is not null //if url have photo then show , if image file picked then show
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
       return  CachedNetworkImage(
                      imageUrl: oldImagePath!,
                      fit: BoxFit.fill,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.broken_image),
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

