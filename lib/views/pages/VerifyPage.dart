// import 'package:flutter/material.dart';

// class VerifyPage extends StatefulWidget {
//   const VerifyPage({super.key});

//   @override
//   State<VerifyPage> createState() => _VerifyPageState();
// }

// class _VerifyPageState extends State<VerifyPage> {
//    final List<TextEditingController> _controllers =
//       List.generate(4, (_) => TextEditingController());
//   final List<FocusNode> _focusNodes =
//       List.generate(4, (_) => FocusNode(), growable: false);
//   void _verify(){
//     String otp = _controllers.map((c) => c.text).join();
//       if (otp.length < 4) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please enter all 4 digits")),
//       );
//       return;
//     }
//       ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Entered OTP: $otp")),
//     );
//   }
//       @override
//   void dispose() {

//     for (var controller in _controllers) {
//       controller.dispose();
//     }
//     for (var node in _focusNodes){
//       node.dispose();
//     }
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//       appBar: AppBar(
//         title: Text('Verify Page'),
//         leading: BackButton(onPressed: () {
//           Navigator.pop(context);
//         }),
//       ),
//       body: Center(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text("Verification code", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
//             SizedBox(height: 10),
//             Text("we sent a verification code to your email"),
//             SizedBox(height: 10),
//             Text("sorvictor@me.com"),
//             SizedBox(height: 30),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: 
//                   List.generate(4, (index) {
//                     return SizedBox(
//                       width: 50,
//                       height: 50,
//                       child: TextField(
//                         controller: _controllers[index],
//                         focusNode: _focusNodes[index],
//                         maxLength: 1,
//                         textAlign: TextAlign.center,
//                         keyboardType: TextInputType.number,
//                         decoration: InputDecoration(
//                           border: OutlineInputBorder(),
//                            counterText: "",
//                         ),
//                         onChanged: (value){
//                           if(value.isNotEmpty && index < (_focusNodes.length -1)){
//                             FocusScope.of(context).requestFocus(_focusNodes[index+1]);
//                           }
//                            if (value.isEmpty && index > 0) {
//                         FocusScope.of(context)
//                             .requestFocus(_focusNodes[index - 1]);
//                       }
//                         },
//                       ),
//                     );
//                   }),
                
                      
//               ),
//            const SizedBox(height: 40),

//             // Verify button
//             Center(
//               child: ElevatedButton(
//                 onPressed: _verify,
//                 child: const Text("Verify"),
//               ),
//             ),
//           ],
//         )
//       ),
//     );
//   }
// }