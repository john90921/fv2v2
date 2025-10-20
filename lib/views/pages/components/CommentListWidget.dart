import 'package:flutter/material.dart';
import 'package:fv2/models/Comment.dart';
import 'package:fv2/models/Post.dart';
import 'package:fv2/models/Reply.dart';
import 'package:fv2/providers/CommentProvider.dart';
import 'package:fv2/providers/PostProvider.dart';
import 'package:fv2/providers/ReplyProvider.dart';
import 'package:fv2/views/WidgetTree.dart';
import 'package:fv2/views/pages/PostPage.dart';
import 'package:fv2/views/pages/components/CommentWidget.dart';
import 'package:fv2/views/pages/components/ConfirmDialog.dart';
import 'package:fv2/views/pages/components/post/Postwidget.dart';
import 'package:fv2/views/pages/components/ReplyWidget.dart';
import 'package:provider/provider.dart';

class CommentListWidget extends StatefulWidget {
  final int postId;
  const CommentListWidget({super.key, required this.postId});

  @override
  State<CommentListWidget> createState() => _CommentListWidgetState();
}

class _CommentListWidgetState extends State<CommentListWidget> {
   void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // wait for widgets to be built then fetch
      Provider.of<CommentProvider>(context, listen: false).fetchComments(widget.postId);
    });
}
  @override
  Widget build(BuildContext context) {
    return Consumer<CommentProvider>(
                    builder: (context, commentProvider, child) {
                      List<Comment>? comments = commentProvider.comments;
                      
                      
                      if(commentProvider.isAddingComment){
                        return Column(
                          children: [
                            const Center(child: CircularProgressIndicator()),
                        ListView.builder(
                        // if have, will return the list of comments
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: comments.length,
                        itemBuilder: (Context, index) {
                          return  CommentWidget(id:comments[index].id, postId: widget.postId); // this will call the CommentWidget to display the comment // need the the comment id
                        },
                      )
                          ],
                        );
                      }
                      else if(commentProvider.isLoading){
                        return const Center(child: CircularProgressIndicator());
                      }
                      else if(comments.length == 0) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("No comments"),
                            );
                          } // if have, will return the list of comments>
                      
                      return ListView.builder(
                        // if have, will return the list of comments
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: comments.length,
                        itemBuilder: (Context, index) {
                        late final ValueNotifier<bool> _showReplies = ValueNotifier<bool>(false);
                        return  ChangeNotifierProvider(
                          create: (context) => ReplyProvider(),
                          child: CommentWidget(id:comments[index].id, postId: widget.postId)); // this will call the CommentWidget to display the comment // need the the comment id
                        },
                      );
                      },
            );
  }
}