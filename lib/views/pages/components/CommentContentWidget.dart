import 'package:flutter/material.dart';
import 'package:fv2/models/Comment.dart';
import 'package:fv2/models/Reply.dart';
import 'package:fv2/providers/CommentProvider.dart';
import 'package:fv2/providers/ReplyProvider.dart';
import 'package:fv2/views/pages/components/ConfirmDialog.dart';
import 'package:fv2/views/pages/components/ReplyWidget.dart';
import 'package:fv2/views/pages/components/ShowReplyBottomSheet.dart';
import 'package:fv2/views/pages/components/showOptionsSheet.dart';
import 'package:provider/provider.dart';

class CommentContentWidget extends StatelessWidget {
  final int id;
  final int postID;
  final ValueNotifier<bool> showReplies;
  const CommentContentWidget({
    super.key,
    required this.id,
    required this.postID,
    required this.showReplies,
  });

  @override
  Widget build(BuildContext context) {
    CommentProvider commentProvider = Provider.of<CommentProvider>(
      context,
      listen: false,
    );
    return Selector<CommentProvider, Comment?>(
      selector: (_, commentProvdier) => commentProvdier.getComemnt(id),
      builder: (_, comment, _) {
        if (comment == null) {
          return const SizedBox.shrink();
        }
        return Container(
          key: ValueKey(comment.id),
          margin: const EdgeInsets.all(10.0),
          padding: const EdgeInsets.all(20.0),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header with avatar + username + time
              ListTile(
                contentPadding: EdgeInsets.zero,
                // leading: CircleAvatar(
                //   backgroundImage: NetworkImage(comment.owner_image),
                // ),
                title: Text(comment.owner_name ?? ''),
                subtitle: Text(comment.getTimeAgo()),
                trailing: IconButton(
                  icon: Icon(Icons.more_horiz),
                  onPressed: () {
                    showOptionsSheet(
                      context: context,
                      onDelete: () => commentProvider.deleteComment(
                        comment.id,
                        postID,
                        context,
                      ),
                       onEdit: () => ShowReplyBottomSheet(context: context,isEdit: true, editContent: commentProvider.editComment, id: comment.id, content: comment.content), 
                      isFromPostPage: false,
                    );

                    //    showModalBottomSheet(
                    //   // show more options
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(20.0),
                    //   ),
                    //   context: context,
                    //   builder: (context) {
                    //     return Padding(
                    //       padding: const EdgeInsets.all(8.0),
                    //       child: Column(
                    //         mainAxisSize: MainAxisSize.min,
                    //         children: [
                    //           ListTile(
                    //             leading: Text(
                    //               "Settings",
                    //               style: TextStyle(
                    //                 fontSize: 20,
                    //                 fontWeight: FontWeight.bold,
                    //               ),
                    //             ),
                    //             trailing: IconButton(
                    //               icon: Icon(Icons.close),
                    //               onPressed: () {
                    //                 Navigator.pop(context);
                    //               },
                    //             ),
                    //           ),
                    //           SizedBox(height: 10),
                    //           ListTile(
                    //             leading: Icon(Icons.edit),
                    //             title: Text('Edit'),
                    //             subtitle: Text('Edit your comment'),

                    //             onTap: () {
                    //               // Handle report button press
                    //             },
                    //           ),
                    //           ListTile(
                    //             leading: Icon(Icons.delete),
                    //             title: Text('delete'),
                    //             subtitle: Text('delete your comment'),

                    //             onTap: () async {
                    //               final bool? confirm = await confirmDialog(
                    //                 context,
                    //               ); // show confirm dialog
                    //               if (confirm == false) {
                    //                 Navigator.pop(context);
                    //                 return;
                    //               }
                    //               String message = await commentProvider
                    //                   .deleteComment(comment.id, postID, context);
                    //               // delete the post
                    //               Navigator.pop(context);

                    //               ScaffoldMessenger.of(context)
                    //                 ..hideCurrentSnackBar()
                    //                 ..showSnackBar(
                    //                   SnackBar(content: Text(message)),
                    //                 );
                    //               // Handle report button press
                    //             },
                    //           ),
                    //         ],
                    //       ),
                    //     );
                    //   },
                    // );
                  },
                ),
              ),

              /// Comment text
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(comment.content),
              ),

              /// Actions (like / reply)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: OverflowBar(
                  alignment: MainAxisAlignment.start,
                  children: [
                    TextButton.icon(
                      icon: comment.is_liked
                          ? Icon(Icons.thumb_up_alt)
                          : Icon(Icons.thumb_up_alt_outlined),
                      label: Text('${comment.likes_count} Likes'),
                      onPressed: () async {
                        await commentProvider.likeComment(comment.id);
                      },
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.reply_rounded, size: 18),
                      label: const Text('Reply'),
                      onPressed: () async {
                        //   ReplyProvider replyProvider = Provider.of<ReplyProvider>(context, listen: false);
                        String? reply = await ShowReplyBottomSheet(
                          context: context,
                        );
                        String? message;
                        if (reply != null) {
                          try{
                            message = await Provider.of<ReplyProvider>(
                              context,
                              listen: false,
                            ).addReply(
                              taged_user_id: comment.owner_id,
                              comment_id: comment.id,
                              content: reply,
                              context: context,
                            );
                          }
                          catch(e){
                            print(e);
                          }
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(message!)));
                        }
                      },
                    ),
                  ],
                ),
              ),

              ///
              if (comment.replies_count > 0) ...[
                Row(
                  children: [
                    const SizedBox(width: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: TextButton(
                        child: ValueListenableBuilder<bool>(
                          valueListenable: showReplies,
                          builder: (context, showReplies, _) {
                            return Text(
                              showReplies
                                  ? 'Hide replies'
                                  : 'View ${comment.replies_count} replies',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                        onPressed: () async {
                          showReplies.value = !showReplies.value;
                          if (showReplies.value) {
                            await Provider.of<ReplyProvider>(
                              context,
                              listen: false,
                            ).fetchReplies(comment.id);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
