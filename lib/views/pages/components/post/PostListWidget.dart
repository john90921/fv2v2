import 'package:flutter/material.dart';
import 'package:fv2/models/Post.dart';
import 'package:fv2/providers/PostProvider.dart';
import 'package:fv2/views/pages/components/post/Postwidget.dart';
import 'package:provider/provider.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'dart:isolate';
import 'dart:convert';
class PostListWidget extends StatefulWidget {
const PostListWidget({super.key});

  @override
  State<PostListWidget> createState() => _PostListWidgetState();
}

class _PostListWidgetState extends State<PostListWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // wait for widgets to be built then fetch
      try {
         final receivePort = ReceivePort();
  Provider.of<PostProvider>(context, listen: false).getTodayPostsData();
} on Exception catch (e) {
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text('Error fetching posts: $e')));
}
          
  });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Today Community Feed",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:Selector<PostProvider, List<int>>(
              selector: (_, provider) => provider.postList.map((p) => p.id).toList(),
              builder: (context, postIdList, child) {
                PostProvider postProvider = Provider.of<PostProvider>(context, listen: false);
                if (postProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  if (postIdList.isEmpty) {
                    return const Text("No posts found");
                  }
                  return Container(
                    constraints: const BoxConstraints(minHeight: 60),
                    child: ListView.separated(
                      // post list
                      shrinkWrap: true, // let it fit inside parent
                      physics: const NeverScrollableScrollPhysics(),
                      // disable scroll
                      itemCount: postIdList.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 50),
                      itemBuilder: (context, index) {
                        final post_id = postIdList[index];
                        return Postwidget(post_id: post_id, isfromPostPage: false);
                        //   onTap: () {
                        //      Navigator.pushNamed(
                        //                         context,
                        //                         '/postPage',
                        //                         arguments: post_id
                        //                       );
                        //   },
                        //   child: Postwidget(post_id: post_id, isfromPostPage: false)
                        // );
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
