import 'package:fv2/models/CommentNotification.dart';
import 'package:fv2/providers/NotificationProvider.dart';
import 'package:fv2/providers/PostProvider.dart';
import 'package:fv2/views/pages/components/notifications/NotificationCard.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NotificationProvider>(context, listen: false)
          .fetchNotifications();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        leading: const BackButton(),
      ),
      body: SafeArea(
        child: Consumer<NotificationProvider>(
        builder: (context, notificationProvider,child) {
            List<dynamic> notifications = notificationProvider.notifications;
          
             if (notificationProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            else if (notifications.isEmpty) {
              return const Center(
                child: Text('No notifications available.'),
              );
            }
            return ListView.builder(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.all(8),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                if(notification is CommentNotification){
                return NotificationCard(
                  title: notification.title ,
                  message: notification.message,
                  time: notification.getTimeAgo(),
                  icon: notification.icon,
                  isRead: notification.is_read,
                  onTap: () async{
  
                    context.loaderOverlay.show();
                    await notificationProvider.markAsRead(notification.id);
                    await Provider.of<PostProvider>(context, listen: false).fetchPostByID(notification.post_id);
                    context.loaderOverlay.hide();

                    Navigator.pushNamed(context, '/postPage', arguments: {
                     'post_id': notification.post_id,
                      'comment_id': notification.comment_id,
                      });
                  },
                );
                }
              },
          );
          },
        ),
      ),
    );
  }
}
