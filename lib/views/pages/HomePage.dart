import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fv2/providers/PostProvider.dart';
import 'package:fv2/views/pages/Disease/PhotoScanConfirm.dart';
import 'package:fv2/views/pages/components/post/PostListWidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:easy_refresh/easy_refresh.dart';
class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final onPressed = () {
    print("Camera Clicked");
  };
  @override
  void initState() {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Provider.of<PostProvider>(context, listen: false).initialHomePage();
  });    
  super.initState();
  }

  Future pickImage(ImageSource source, BuildContext context) async {
    // Use image_picker package to pick image from gallery or camera
    try {
context.loaderOverlay.show();
      final image = await ImagePicker().pickImage(source: source);
      context.loaderOverlay.hide();
      if (image == null) return;
      final imageTemporary = File(image.path);
     if(mounted){ Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PhotoScanConfirm(newImage: imageTemporary),
        ),
      );}
   
    } on PlatformException catch (e) {
      print("Failed to pick image: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
   PostProvider postProvider = Provider.of<PostProvider>(context,listen:false); // get post
    return EasyRefresh(
                      onRefresh: postProvider.getTodayPostsDataTesting,
                      onLoad: postProvider.hasMore ? postProvider.LoadMoreTodayPostsData : null,
                      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(25.0),
            decoration: BoxDecoration(
              color: Color(0xFF2563EB),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Scan Plant disease',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),

                ),
                const SizedBox(height: 10),
                const Text(
                  "Take or upload a photo to identify plant diseases instantly",
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, // button bg
                          foregroundColor: Colors.blue, // icon & text color
                        ),
                        onPressed: () {
                         if(mounted)
                         { Navigator.pushNamed(context, '/photoGuide');}
                        },
                        icon: const Icon(Icons.camera_alt_outlined),
                        label: const Text("Camera"),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, // button bg
                          foregroundColor: Colors.blue, // icon & text color
                        ),
                        onPressed: () async{
                         await pickImage(ImageSource.gallery,context);
                        },
                        icon: const Icon(Icons.image_outlined),
                        label: const Text("Gallery"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        
          // Container(
          //   width: double.infinity,
          //   padding: const EdgeInsets.all(15.0),
          //   decoration: BoxDecoration(
          //     color: Colors.white,
          //     borderRadius: BorderRadius.circular(8.0),
      
          //   ),
          //   child: Row(children: [
          //     Icon( Icons.people, color: Colors.blue, size: 30),
          //     SizedBox(width: 10),
          //     Text("User Management"),
          //     Spacer(),
          //     IconButton(onPressed: onPressed, icon: Icon(Icons.arrow_forward_ios))
          //   ],),
          // ),
          SizedBox(height: 20),
          Text(
            "Week Community Feed",
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          PostListWidget(),
          ],
        ),
      ),
    );
  }
}
