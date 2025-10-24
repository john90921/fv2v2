import 'package:flutter/material.dart';
import 'package:fv2/providers/CommentProvider.dart';
import 'package:fv2/providers/NotificationProvider.dart';
import 'package:fv2/providers/PostProvider.dart';
import 'package:fv2/providers/UserProvider.dart';
import 'package:fv2/token/TokenManager.dart';
import 'package:fv2/views/WidgetTree.dart';
import 'package:fv2/views/pages/CommunityPage.dart';
import 'package:fv2/views/pages/NotificationPage.dart';
import 'package:fv2/views/pages/PostFormPage.dart';
import 'package:fv2/views/pages/HomePage.dart';
import 'package:fv2/views/pages/LoginPage.dart';
import 'package:fv2/views/pages/PostPage.dart';
import 'package:fv2/views/pages/WebSocketTestPage.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  final token = await TokenManager.instance.loadAccessToken();
  final String firstStartRoute = token != null ? '/home' : '/login';

  

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PostProvider()),
        ChangeNotifierProvider(create: (context) => Userprovider()),
        ChangeNotifierProvider(create: (context) => CommentProvider()),
        ChangeNotifierProvider(create: (context) => NotificationProvider()),
        ChangeNotifierProxyProvider<PostProvider,CommentProvider>(
          create: (_) => CommentProvider(), 
          update: (_,postProvider,commentProvider) =>
            commentProvider!..setPostProvider(postProvider),
          )
      ],
      child: MyApp(firstStartRoute : firstStartRoute),
    ),
    );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key,required this.firstStartRoute});
  final String firstStartRoute;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a purple toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 58, 141, 183)),
      ),
        initialRoute: firstStartRoute,
        routes: {
          '/postPage':(context) => const WidgetTree(body: PostPage(), backbutton: true),
          '/postFormPage':(context) => const WidgetTree(body: PostFormPage(), backbutton: true),
          '/login': (context) => LoaderOverlay(child: const WidgetTree(body: CommunityPage(),backbutton: false)),
          '/NotificationPage': (context) => LoaderOverlay(child: NotificationPage()),
          '/home': (context) => LoaderOverlay(child: const WidgetTree(body: CommunityPage(),backbutton: false)),
          '/communityPage':(context) => LoaderOverlay(child: const WidgetTree(body: CommunityPage(),backbutton: false)),
        },
          // home: WidgetTree(body: const Homepage()),
      ),
    );
  }
}

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Home")),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => const Homepage()),
//             );
//           },
//           child: const Text("Go to Second Screen"),
//         ),
//       ),
//     );
//   }
// }
  