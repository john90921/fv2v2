import 'package:flutter/material.dart';
import 'package:fv2/models/Post.dart';
import 'package:fv2/providers/PostProvider.dart';
import 'package:fv2/views/pages/PostFormPage.dart';
import 'package:fv2/views/pages/components/ConfirmDialog.dart';
import 'package:fv2/views/pages/components/showOptionsSheet.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Postwidget extends StatelessWidget {
  final int post_id;
  final bool isfromPostPage;
  const Postwidget({
    super.key,
    required this.post_id,
    required this.isfromPostPage,
  });
  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context, listen: true);
    return Selector<PostProvider, Post?>(
      selector: (_, provider) => provider.getPost(post_id),
      builder: (_, post, __) {
        if (post == null) return const SizedBox.shrink();
        return Container(
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.only(bottom: 16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: CircleAvatar(
                  radius: 24,
                  backgroundImage: post.ownerImage != null
                      ? CachedNetworkImageProvider(post.ownerImage!)
                      : null,
                  child: post.ownerImage == null
                      ? const Icon(Icons.person, color: Colors.white)
                      : null,
                ),
                title: Text(post.ownerName), // User name
                subtitle: Text(post.getTimeAgo()), // Post time
                trailing: IconButton(
                  icon: Icon(Icons.more_horiz),
                  onPressed: () {
                    {
                      try {
                        showOptionsSheet(
                          context: context,
                          onDelete: () =>
                              postProvider.deletePost(post.id, context),
                          onEdit: () async{
  
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PostFormPage(post: post),
                              ),
                            );
                          },
                          isFromPostPage: false,
                        );
                      } catch (e) {
                        print("error $e");
                      }
                    }
                  },
                ), // More options icon
              ),
               Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(post.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ), 
                ),// Post title
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(post.content), // Post content
              ),
              if (post.image != null && post.image!.isNotEmpty) ...[
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: post.image!,
                    fit: BoxFit.fill,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.broken_image),
                  ),
                ),
              ],
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OverflowBar(
                  alignment: MainAxisAlignment.start,
                  children: [
                    TextButton.icon(
                      icon: post.isLiked
                          ? Icon(Icons.thumb_up_alt)
                          : Icon(Icons.thumb_up_alt_outlined),
                      label: Text('${post.likesCount} Likes'),
                      onPressed: () async {
                        await postProvider.likePost(post.id);
                      },
                    ),
                    TextButton.icon(
                      icon: Icon(Icons.comment_outlined),
                      label: Text('${post.commentsCount} Comment'),
                      onPressed: () {
                        // Handle comment button press
                        if (!isfromPostPage) {
                          Navigator.pushNamed(
                            context,
                            '/postPage',
                            arguments: post.id,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
