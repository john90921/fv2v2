import 'package:flutter/material.dart';
import 'package:fv2/models/Post.dart';
import 'package:fv2/providers/CommentProvider.dart';
import 'package:fv2/providers/PostProvider.dart';
import 'package:fv2/views/pages/components/CommentListWidget.dart';
import 'package:fv2/views/pages/components/post/Postwidget.dart';
import 'package:provider/provider.dart';

// class PostPage extends StatelessWidget {
//   const PostPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

class PostPage extends StatefulWidget {
  const PostPage({super.key});
  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  late int postId;
  bool _loaded = false;
  late Post? post;

  // @override
  // void didChangeDependencies() { // called when the widget is inserted into the tree
  //   super.didChangeDependencies();

  //     _loaded = true; // set loaded to true to prevent reload ain

  // }
  @override
  void dispose() {
    // TODO: implement dispose
    _commentController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      postId = ModalRoute.of(context)!.settings.arguments as int;
      post = Provider.of<PostProvider>(context, listen: false).getPost(postId); // get post from provider

      _loaded = true;
    }
  }

  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print('Post ID: $postId');
    if (post == null) {
      return const Center(child: Text("Post deleted or not found"));
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          Postwidget(post_id: postId, isfromPostPage: true),
          Divider(),
          Column(
            children: [
              Container(
                // Comment input field
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          "https://static0.srcdn.com/wordpress/wp-content/uploads/2024/02/nami-from-one-piece.jpg",
                        ), // User avatar image
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _commentController,
                          minLines: 1, // Start with 1 line
                          maxLines: null,
                          // Expand infinitely as user types
                          decoration: InputDecoration(
                            hintText: "Add a comment...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () async {
                          print(_commentController.text);
                          String content = _commentController.text.trim();
                          if (content.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Comment cannot be empty"),
                              ),
                            );
                            return;
                          }
                          FocusScope.of(context).unfocus(); // Hide keyboard
                          _commentController.clear();

                          // Clear immediately for better UX
                          try {
                            String? message =
                                await Provider.of<CommentProvider>(
                                  context,
                                  listen: false,
                                ).addComments(postId, content, context);
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(SnackBar(content: Text(message!)));
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Failed to add comment: $e"),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
    // check if post has comments
          CommentListWidget(postId: post!.id), // if not, just return "no comments yet"
        ],
      ),
    );
  }
}
