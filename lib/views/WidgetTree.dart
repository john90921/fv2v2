// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:fv2/providers/NotificationProvider.dart';
// import 'package:fv2/providers/UserProvider.dart';
// import 'package:fv2/views/pages/CommunityPage.dart';
// import 'package:fv2/views/pages/HomePage.dart';

// import 'package:provider/provider.dart';

// class WidgetTree extends StatefulWidget {
//   // widget tree must in main route
//   const WidgetTree({super.key, required this.body, required this.backbutton});
//   final Widget body;
//   final bool backbutton;


//   @override
//   State<WidgetTree> createState() => _WidgetTreeState();
// }

// class _WidgetTreeState extends State<WidgetTree> {
//   final List<Widget> _pages = [
//     Homepage(),
//     CommunityPage(),
//   ];
//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<NotificationProvider>(
//         context,
//         listen: false,
//       ).fetchUnreadCount();
//     });
//     // TODO: implement initState
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
    
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       appBar: AppBar(
//         leading: widget.backbutton ? const BackButton() : null,
//         automaticallyImplyLeading: false,
//         title: const Text('Widget Tree'),
//         centerTitle: false,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () async {
//               bool logoutStatus = await Provider.of<Userprovider>(
//                 context,
//                 listen: false,
//               ).logout(context);
//               if (logoutStatus) {
//                 if (context.mounted) {
//                   Navigator.of(context).pushReplacementNamed('/login');
//                 }
//               } else {
//                 if (context.mounted) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text("Logout failed")),
//                   );
//                 }
//               }
//             },
//           ),
//           Consumer<NotificationProvider>(
//             // listen to notification provider to get unread count
//             builder: (context, notificationProvider, child) {
//               int unreadCount = notificationProvider.unread_count;
//               return IconButton(
//                 // show notification icon with unread count badge
//                 icon: Stack(
//                   children: [
//                     Icon(
//                       Icons.notifications,
//                       color: unreadCount > 0 ? Colors.blue : Colors.white,
//                     ),
//                     if (unreadCount > 0)
//                       Positioned(
//                         right: 0,
//                         top: 0,
//                         child: Container(
//                           padding: const EdgeInsets.all(2),
//                           decoration: const BoxDecoration(
//                             color: Colors.red,
//                             shape: BoxShape.circle,
//                           ),
//                           constraints: const BoxConstraints(
//                             minWidth: 16,
//                             minHeight: 16,
//                           ),
//                           child: Text(
//                             '$unreadCount',
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 10,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//                 onPressed: () {
//                   Navigator.pushNamed(context, '/NotificationPage');
//                 },
//               );
//             },
//           ), // show notification icon with unread count badge
//           SizedBox(width: 20), // Add some spacing at the en
//         ],
//       ),
//       body: SafeArea(
//         child: Padding(padding: const EdgeInsets.all(8.0), child: widget.body),
//       ),
//       // ChangeNotifierProvider<PostProvider>(create: (context) => PostProvider(), child: Homepage()),
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.group),
//             label: 'Community',
//           ),
//           BottomNavigationBarItem(icon: Icon(Icons.school), label: 'School'),
//         ],
//         currentIndex: 0,
//         selectedItemColor: Colors.amber[800],
//         onTap: (int index) {
//           switch (index) {
//             case 0:
//               Navigator.pushNamed(context, '/home');
//               break;
//             case 1:
//               Navigator.pushNamed(context, '/communityPage');
//               break;
//             case 2:
//               Navigator.pushNamed(context, '/schoolPage');
//               break;
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: const Icon(Icons.add),
//         onPressed: () {
//           Navigator.pushNamed(context, '/postFormPage');
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:fv2/providers/HmsPushProvider.dart';
import 'package:fv2/providers/NotificationProvider.dart';
import 'package:fv2/providers/PostProvider.dart';
import 'package:fv2/providers/UserProvider.dart';
import 'package:fv2/views/pages/CommunityPage.dart';
import 'package:fv2/views/pages/HomePage.dart';
import 'package:fv2/views/pages/profile/ProfilePage.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'package:provider/provider.dart';

class WidgetTree extends StatefulWidget {
  // widget tree must in main route
  const WidgetTree({super.key});


  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  final List<Widget> _pages = [
    LoaderOverlay(child:  Homepage()),
    LoaderOverlay(child:  CommunityPage()),
     LoaderOverlay(child:  ProfilePage()),
    // ChangeNotifierProvider(
    //     create: (_) => PostProvider(),
    //     child: LoaderOverlay(child:  Homepage()),
    //   ),
    // ChangeNotifierProvider(
    //     create: (_) => PostProvider(),
    //     child: LoaderOverlay(child:  CommunityPage()),
    //   ),
  ];
  int _currentIndex = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      if (!mounted) return;
      await Provider.of<Userprovider>(context, listen: false).setUserInfo();
      await Provider.of<NotificationProvider>(
        context,
        listen: false,
      ).fetchUnreadCount();
      
      // Initialize HMS Push for receiving notifications
      try {
        await Provider.of<HmsPushProvider>(context, listen: false).initialize();
        print('HMS Push initialized in WidgetTree');
      } catch (e) {
        print('Error initializing HMS Push: $e');
      }
    });
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Widget Tree'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Unregister push token before logout
              try {
                await Provider.of<HmsPushProvider>(context, listen: false).unregister();
              } catch (e) {
                print('Error unregistering push token: $e');
              }
              
              bool logoutStatus = await Provider.of<Userprovider>(
                context,
                listen: false,
              ).logout(context);
              if (!mounted) return; 
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
        child: IndexedStack(
          index: _currentIndex,
          children: _pages,
        )
      ),
      // ChangeNotifierProvider<PostProvider>(create: (context) => PostProvider(), child: Homepage()),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Community',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        selectedItemColor: Colors.amber[800],
        onTap: (int index) {
          if(index != 2){
            Provider.of<PostProvider>(context, listen: false).initial();
            Provider.of<PostProvider>(context, listen: false).getTodayPostsDataTesting();
          }
            setState(() => _currentIndex = index);
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
