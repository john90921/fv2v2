
import 'package:flutter/material.dart';
import 'package:fv2/models/Comment.dart';
import 'package:fv2/models/Reply.dart';
import 'package:fv2/providers/CommentProvider.dart';
import 'package:fv2/providers/ReplyProvider.dart';
import 'package:fv2/views/pages/components/CommentContentWidget.dart';
import 'package:fv2/views/pages/components/ReplyWidget.dart';
import 'package:fv2/views/pages/components/ShowReplyBottomSheet.dart';
import 'package:provider/provider.dart';

class CommentWidget extends StatefulWidget {
  final int id; //comment id
  final int postId;
  const CommentWidget({super.key, required this.id, required this.postId}); //the id is the comment id

  
  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  late final ValueNotifier<bool> _showReplies;
  late CommentProvider commentProvider;

  @override
  void initState() {
    _showReplies = ValueNotifier(false);
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    

  
  return Container(
  
            margin: const EdgeInsets.all(10.0),
            padding: const EdgeInsets.all(20.0),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              color: Colors.white,
            ),

    child: Column(
      
      children: [
        CommentContentWidget(id:widget.id, postID: widget.postId, showReplies: _showReplies),
        ValueListenableBuilder<bool>(
                          valueListenable: _showReplies,
                          builder: (context, showReplies, child) {
                            if (!showReplies) return const SizedBox.shrink();
        
        
                            return Consumer<ReplyProvider>(
                              builder: (context, replyProvider, child) {
                              List<Reply> replies = replyProvider.replies;
                              if(replyProvider.isLoading){
                                return const Center(child: CircularProgressIndicator());
                              }
                              if(replies.isEmpty){
                                return const Center(child: Text('No replies yet'));
                              }
                              return ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: replies.length,
                                itemBuilder: (context, index) {
                                  return ReplyWidget(
                                    id:replies[index].id);
                                  // final reply = comment.replies![index];
                                  // return ReplyWidget();
                                },
                              );
                              },
                            );
                          },
                        ),
         
         
      ],
    ),
  );
  }
}
