import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final String title;
  final String message;
  final String time;
  final IconData icon;
  final bool isRead;
  final Function()? onTap;
  const NotificationCard({
    super.key,
    required this.title,
    required this.message,
    required this.time,
    this.icon = Icons.notifications,
    this.isRead = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isRead ? const Color.fromARGB(255, 126, 124, 124) : Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: Icon(icon, color: Colors.blue),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("${message}\n${time}"),
        trailing: IconButton(onPressed: ()=>{
          onTap != null ? onTap!() : null
        }, icon: const Icon(Icons.arrow_forward_ios_rounded)),

      ),
    );
  }
}
