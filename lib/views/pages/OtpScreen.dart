import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fv2/views/pages/ResetPassword.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:fv2/api/ApiHelper.dart';


class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.gmail});
  final String gmail;
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  // 4 controllers + 4 focus nodes
  final List<TextEditingController> _controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    4,
    (_) => FocusNode(),
    growable: false,
  );

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  /// Function to collect OTP
  Future<String?> _verifyOtp(BuildContext context, String gmail) async {
    String otp = _controllers.map((c) => c.text).join();

    if (otp.length < 4) {
      return "Please enter all 4 digits";
    }

    ApiResult result = await Apihelper.post(
      ApiRequest(
        path: "/submitOtp",
        data: {"email": widget.gmail,"otp":otp},
      ),
    );

    if (result.status == true) {
      return null;
    } else {
      return result.message;
    }
    // final Dio _dio = DioHandler.instance.dio;

    // try {
    //   final response = await _dio.post(
    //     "/submitOtp",
    //     data: {"email": gmail, "otp": otp},
    //   );

    //   if (response.data['status'] == true) {
    //     // check status
    //     ScaffoldMessenger.of(context)
    //       ..hideCurrentSnackBar()
    //       ..showSnackBar(
    //         const SnackBar(content: Text("Verification successful")),
    //       );
    //     WidgetsBinding.instance.addPostFrameCallback((_) {
    //       Navigator.pushReplacement(
    //         //direct to reset password
    //         context,
    //         MaterialPageRoute(
    //           builder: (context) => ResetPasswordPage(gmail: gmail),
    //         ),
    //       );
    //     });
    //   } else {
    //     return "invalid otp";
    //   }
    // } on DioException catch (e) {
    //   if (e.response != null) {
    //     return "Error: ${e.response?.statusCode} - ${e.response?.data}"; //
    //   } else {
    //     return "error ${e.message}"; // network error
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verification Code")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Verification code",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text("We sent a verification code to your email"),
            const SizedBox(height: 10),
            Text(widget.gmail),
            const SizedBox(height: 30),

            // OTP fields
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                return SizedBox(
                  width: 50,
                  height: 50,
                  child: TextFormField(
                    inputFormatters: [
                      FilteringTextInputFormatter
                          .digitsOnly, // allow only digits
                    ],
                    controller: _controllers[index],
                    maxLength: 1,
                    focusNode: _focusNodes[index],
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      counterText: "",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty && index < _focusNodes.length - 1) {
                        FocusScope.of(
                          context,
                        ).requestFocus(_focusNodes[index + 1]);
                      }
                    },
                  ),
                );
              }),
            ),
            const SizedBox(height: 40),

            // Verify button
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  context.loaderOverlay.show();
                  String? result = await _verifyOtp(context, widget.gmail);
                  context.loaderOverlay.hide();
                  if (result == null) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        const SnackBar(
                          content: Text("Verification successful"),
                        ),
                      );
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.pushReplacement(
                        //direct to reset password
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResetPasswordPage(gmail: widget.gmail),
                        ),
                      );
                    });
                  }else {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(SnackBar(content: Text(result)));
                  }
                },
                child: const Text("Verify"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
