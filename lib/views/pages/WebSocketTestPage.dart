// import 'package:flutter/material.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'dart:convert';

// class WebSocketTestPage extends StatefulWidget {
//   const WebSocketTestPage({super.key});

//   @override
//   State<WebSocketTestPage> createState() => _WebSocketTestPageState();
// }

// class _WebSocketTestPageState extends State<WebSocketTestPage> {
//   late final WebSocketChannel channel;
//   final TextEditingController _controller = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     channel = WebSocketChannel.connect(
//       Uri.parse('ws://127.0.0.1:8080/app/my-app-key'), // 👈 change this to your IP
//     );
//     channel.sink.add(jsonEncode({
//       "event": "pusher:subscribe",
//       "data": {"channel": "jojo"}
//     }));

//     channel.stream.listen((event) {
//       print('Received: $event');
//         final data = jsonDecode(event);
//   if (data['event'] == 'pusher:ping') {
//     channel.sink.add(jsonEncode({"event": "pusher:pong"}));
//   }
//   print(data);
//     }, onError: (error) {
//       print('Error: $error');
//     }, onDone: () {
//       print('Socket closed');
//     });
//   }

//   void _sendMessage() {
//     final text = _controller.text.trim();
//     if (text.isNotEmpty) {
//       final jsonMessage = jsonEncode({
//         "event": "message.sent",
//         "data": {"message": text},
//       });
//       channel.sink.add(jsonMessage);
//       _controller.clear();
//     }
//   }

//   @override
//   void dispose() {
//     channel.sink.close();
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("WebSocket Test")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(controller: _controller, decoration: const InputDecoration(labelText: "Enter message")),
//             const SizedBox(height: 16),
//             ElevatedButton(onPressed: _sendMessage, child: const Text("Send")),
//           ],
//         ),
//       ),
//     );
//   }
// }
