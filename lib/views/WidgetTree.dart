import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fv2/providers/NotificationProvider.dart';
import 'package:fv2/providers/UserProvider.dart';
import 'package:provider/provider.dart';

class WidgetTree extends StatelessWidget {
  // widget tree must in main route
  const WidgetTree({super.key, required this.body, required this.backbutton});
  final Widget body;
  final bool backbutton;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NotificationProvider>(
        context,
        listen: false,
      ).fetchUnreadCount();
    });
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: backbutton ? const BackButton() : null,
        automaticallyImplyLeading: false,
        title: const Text('Widget Tree'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              bool logoutStatus = await Provider.of<Userprovider>(
                context,
                listen: false,
              ).logout(context);
              if (logoutStatus) {
                if (context.mounted) {
                  Navigator.of(context).pushReplacementNamed('/login');
                }
              } else {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Logout failed")),
                  );
                }
              }
            },
          ),
          Consumer<NotificationProvider>(
            // listen to notification provider to get unread count
            builder: (context, notificationProvider, child) {
              int unreadCount = notificationProvider.unread_count;
              return IconButton(
                // show notification icon with unread count badge
                icon: Stack(
                  children: [
                    Icon(
                      Icons.notifications,
                      color: unreadCount > 0 ? Colors.blue : Colors.white,
                    ),
                    if (unreadCount > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '$unreadCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/NotificationPage');
                },
              );
            },
          ), // show notification icon with unread count badge
          SizedBox(width: 20), // Add some spacing at the en
        ],
      ),
      body: SafeArea(
        child: Padding(padding: const EdgeInsets.all(8.0), child: body),
      ),
      // ChangeNotifierProvider<PostProvider>(create: (context) => PostProvider(), child: Homepage()),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Community',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'School'),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.amber[800],
        onTap: (int index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/home');
              break;
            case 1:
              Navigator.pushNamed(context, '/communityPage');
              break;
            case 2:
              Navigator.pushNamed(context, '/schoolPage');
              break;
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/postFormPage');
        },
      ),
    );
  }
}
