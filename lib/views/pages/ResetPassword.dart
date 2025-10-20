import 'package:flutter/material.dart';
import 'package:fv2/api/ApiHelper.dart';

import 'package:loader_overlay/loader_overlay.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key, required this.gmail});
  final String gmail;
  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Future<String?> resetPassword() async {
  //   // Add your reset password logic here
  //   String newPassword = _newPasswordController.text;
  //   String confirmPassword = _confirmPasswordController.text;

  //   if (newPassword.isEmpty || confirmPassword.isEmpty) {
  //     return "Please fill in all fields";
  //   } else if (newPassword != confirmPassword) {
  //     return "Passwords do not match";
  //   } else {
  //     final Dio _dio = DioHandler.instance.dio;

  //     try {
  //       final response = await _dio.post(
  //         "/changePassword",
  //         data: {"email": widget.gmail, "password": confirmPassword},
  //       );

  //       if (response.data['status'] == true) {
  //         return null;
  //       } else {
  //         return response.data['message'];
  //       }
  //     } on DioException catch (e) {
  //       if (e.response != null) {
  //         return "Error: ${e.response?.statusCode} - ${e.response?.data}"; //
  //       } else {
  //         return "error ${e.message}"; // network error
  //       }
  //     }
  //   }
  // }

 
  Future<String?> resetPassword() async {
    // Add your reset password logic here
    String newPassword = _newPasswordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      return "Please fill in all fields";
    } else if (newPassword != confirmPassword) {
      return "Passwords do not match";
    } else {

    ApiResult result = await Apihelper.post(ApiRequest(path: "/changePassword", data: {"email": widget.gmail, "password": confirmPassword}));

      if (result.status == true) {
        return null;
      } else {
        return result.message;
      }
    }
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
        leading: BackButton(),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Reset Password Page',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text("This is where the reset password form will go."),
            SizedBox(height: 20),

            TextField(
              controller: _newPasswordController,
              decoration: InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                context.loaderOverlay.show();
                String? result = await resetPassword();
                context.loaderOverlay.hide();
                if (result == null) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Password reset successfully, please login again",
                        ),
                      ),
                    );
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (Route<dynamic> route) => false,
                  );
                }
                else{
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text(result)));
                }
              },
              child: Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}
