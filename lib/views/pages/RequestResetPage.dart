import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fv2/dio/DioHandler.dart';
import 'package:fv2/utils/message_helper.dart';
import 'package:fv2/views/pages/OtpScreen.dart';
import 'package:loader_overlay/loader_overlay.dart';

class RequestResetPage extends StatefulWidget {
  const RequestResetPage({super.key});

  @override
  State<RequestResetPage> createState() => _RequestResetPageState();
}

class _RequestResetPageState extends State<RequestResetPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
 

  void _requestReset(String email) async {  
    final Dio _dio = DioHandler.instance.dio;
    bool status = false;
  

            try {
     
              final response = await _dio.post(
                "/forgetPassword",
                data: {"email": email},
              );
              if (response.data['status'] == true) {
                // WidgetsBinding.instance.addPostFrameCallback((_) {
                //   Navigator.pushReplacement(
                //     //direct to reset password

                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => LoaderOverlay(child: OtpScreen(gmail: gmail)),
                //     ),
                //   );
                // });
                showMessage(context:context,message:  "Otp sent to your email.");
                status = true;
                  
                
                return null; // success
              } else if (response.data['status'] == false) {
                showMessage(context:context,message:  "Error");
                print("Error: ${response.data['message']}");
              }
            } on DioException catch (e) {
              if (e.response != null) {
                print ("Error: ${e.response?.statusCode} - ${e.response?.data}"); // ❌ 401, 404, 500, etc. → Dio throws → handled in catch (DioException).
              } else {
                print("Error: ${e.message}"); //network error
              }
            }
            if(status){
            if(!mounted) return;
                  Navigator.pushReplacement(
                     context,
                        MaterialPageRoute(
                          builder: (context) => OtpScreen(gmail:email, isForResetPassword: true),
                        ),
                  );
            }


  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        leading: const BackButton(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Reset Your Password',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Please enter your registered email address to receive password reset instructions.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
          
                  // Email Input Field
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
          
                  const SizedBox(height: 25),
          
                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async{
                        if (_formKey.currentState!.validate()) {
                         _requestReset(_emailController.text);
                        }
                      },
                      child: const Text('Send Reset Link'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
