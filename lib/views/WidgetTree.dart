import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fv2/providers/UserProvider.dart';
import 'package:provider/provider.dart';


class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key, required this.body, required this.backbutton});
  final Widget body;
  final bool backbutton;
  @override
  Widget build(BuildContext context) {
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
            onPressed: () async{
              bool logoutStatus = await Provider.of<Userprovider>(context, listen: false).logout(context);
              if(logoutStatus){
                if(context.mounted){
                  Navigator.of(context).pushReplacementNamed('/login');
                }
              }
              else{
                if(context.mounted){
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Logout failed")),
                  );
                }
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notification icon press
            },
          ),
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline_outlined),
            onPressed: () {
              // Handle search icon press
            },
          ),
          SizedBox(width: 20), // Add some spacing at the en
        ],
      ),
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: body,
      )),
      // ChangeNotifierProvider<PostProvider>(create: (context) => PostProvider(), child: Homepage()),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.amber[800],
        onTap: (int index) {
          // Handle navigation tap
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
        Navigator.pushNamed(context, '/postFormPage');
      }
    ),
    );
  }
}