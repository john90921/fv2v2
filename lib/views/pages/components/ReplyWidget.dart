import 'package:flutter/material.dart';
import 'package:fv2/models/Comment.dart';
import 'package:fv2/models/Reply.dart';
import 'package:fv2/providers/ReplyProvider.dart';
import 'package:fv2/views/pages/components/ShowReplyBottomSheet.dart';
import 'package:fv2/views/pages/components/showOptionsSheet.dart';
import 'package:provider/provider.dart';

class ReplyWidget extends StatefulWidget {
  final int id; //reply id
  const ReplyWidget({super.key,required this.id});



  @override
  State<ReplyWidget> createState() => _ReplyWidgetState();
}

class _ReplyWidgetState extends State<ReplyWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  
  }

  @override
  Widget build(BuildContext context) {
  final replyProvider = Provider.of<ReplyProvider>(context, listen: false);

    return Selector<ReplyProvider, Reply?>(
      selector: (_, replyProvider) => replyProvider.getReply(widget.id),
      builder: (_, reply, _) => Container(
        margin: EdgeInsets.only(left: 30.0),
        padding: const EdgeInsets.all(8.0),
      
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          border: Border(bottom: BorderSide(color: const Color.fromARGB(255, 6, 6, 6))),
        ),
        child: Column(
              key:ValueKey(reply!.id),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      "https://static0.srcdn.com/wordpress/wp-content/uploads/2024/02/nami-from-one-piece.jpg",
                    ), // User avatar image
                  ),
                  title: Text(reply!.owner_name), // User name
                  subtitle: Text(reply.getTimeAgo()), // Post time
                  trailing: IconButton(icon: Icon(Icons.more_horiz),onPressed: () => 
                  showOptionsSheet(
                    context: context, 
                    onDelete: () => replyProvider.deleteReply(reply.id,reply.comment_id, context),
                    onEdit: () => ShowReplyBottomSheet(context: context,isEdit: true, editContent: replyProvider.editReply, id: reply.id, content: reply.content), 
                    isFromPostPage: false
                  ),), // More options icon
                ),
                ListTile(
  leading: const SizedBox(width: 10), // Align with avatar
  title: Text.rich(
    TextSpan(
      children: [
        TextSpan(
          text: "@${reply.taged_name} ",
          style: const TextStyle(
            color: Colors.blue, // Blue for tagged name
            fontWeight: FontWeight.bold,
          ),
        ),
        TextSpan(
          text: reply.content,
          style: const TextStyle(
            color: Colors.black, // Normal text color
          ),
        ),
      ],
    ),
  ),
),

                 Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OverflowBar(
                    alignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 10),
                      TextButton.icon(
                        icon: reply.isLiked? Icon(Icons.thumb_up_alt) : Icon(Icons.thumb_up_alt_outlined),
                        label: Text(reply.likes_count.toString()),
                        onPressed: () async{
                          await replyProvider.likeReply(reply.id);
                        },
                      ),
                      TextButton.icon(
                        icon: Icon(Icons.reply_rounded),
                        label: Text('reply'),
                        onPressed: () async {
                          String? message;
    
                          // message = await ShowReplyBottomSheet(context, reply.owner_id,reply.comment_id);}
                          String? replyResult = await ShowReplyBottomSheet(context:  context);
                          print(replyResult);
                          
                          if (replyResult == null) return;

                          message = await replyProvider.addReply(taged_user_id: reply.taged_user_id, content:replyResult,comment_id: reply.comment_id, context: context);

                        
                          if (message!= null){
                           ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(SnackBar(content: Text(message)));
                          }
                        },
                      ),
                    ],
                  ),
                ),
                
              ],
            )
          
        
      ),
    );
  }
}
