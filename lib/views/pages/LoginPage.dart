import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:fv2/api/ApiHelper.dart';
import 'package:fv2/dio/DioHandler.dart';
import 'package:fv2/providers/UserProvider.dart';
import 'package:fv2/token/TokenManager.dart';
import 'package:fv2/views/WidgetTree.dart';
import 'package:fv2/views/pages/HomePage.dart';
import 'package:fv2/views/pages/OtpScreen.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

const users = {'dribbble@gmail.com': '12345', 'hunter@gmail.com': 'hunter'};

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  Duration get loginTime => const Duration(milliseconds: 2250);

  Future<String?> _authUser(LoginData data, BuildContext context) async {
    try {
  ApiResult result = await Apihelper.post(
    ApiRequest(
      path: "/login",
      data: {"email": data.name, "password": data.password},
    ),
  );
  
  if (result.status == true) {
    final token = result.data["token"];
    if (token != null) {
      await TokenManager.instance.saveAccessToken(token); // login success
    }
    final saveToken = await TokenManager.instance.loadAccessToken();
    print("login successfull, {$saveToken}");
    print("user data: ${result.data}");
    Map<String, dynamic> user = result.data["user"] as Map<String, dynamic>;
    Provider.of<Userprovider>(context, listen: false).login(user);
    return null;
  } else {
    print("Login failed: ${result.message}");
    return "error : ${result.message}";
  }
} catch (e) {
  print("Login error: $e");
  // TODO
}
    // final Dio _dio = DioHandler.instance.dio;

    // try {
    //   final response = await _dio.post(
    //     "/login",
    //     data: {"email": data.name, "password": data.password},
    //   );
    //   if (response.data["status"] == true) {
    //     final token = response.data['token'];
    //     if (token != null) {
    //       await TokenManager.instance.saveAccessToken(token); // login success
    //     }
    //     return null;
    //     // final saveToken = await TokenManager.instance.loadAccessToken();
    //     // print("login successfull, {$saveToken}");
    //   }
    //   else{
    //     return "${response.data['message']}";
    //   }
    // } on DioException catch (e) {
    //   if (e.response != null) {
    //     print("Error: ${e.response?.statusCode} - ${e.response?.data}");

    //     return "Error: ${e.response?.statusCode} - ${e.response?.data}";
    //   } else {
    //     print("Error: ${e.message}");

    //     return "error";
    //   }
    // }
  }

  // Future<String?> _recoverPassword(String name, BuildContext context) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => const ResetPassword())
  //     );

  //   print(name);

  //   return Future.delayed(loginTime).then((_) {

  //   });
  // }

  Future<String?> _signupUser(SignupData data, BuildContext context) async {

  final email = data.name ?? '';
  final password = data.password ?? '';
  final fullname = data.additionalSignupData?['fullname'] ?? '';
  if (email.isEmpty || password.isEmpty || fullname.isEmpty) {
    return 'Please fill in all fields';
  }
  try {
    ApiResult result = await Apihelper.post(
    ApiRequest(
      path: "/user",
      data: {"name": fullname, "email": email, "password": password},
    ),
  );

    if (result.status == true) {
        final token = result.data["token"];
    if (token != null) {
      await TokenManager.instance.saveAccessToken(token); // login success
    }
    final saveToken = await TokenManager.instance.loadAccessToken();
    
    print("login successfull, {$saveToken}");
    print("user data: ${result.data}");
    Map<String, dynamic> user = result.data["user"] as Map<String, dynamic>;
    Provider.of<Userprovider>(context, listen: false).login(user);
        return "success register"; // success
      } else {
        return('Registration failed: ${result.message}');
      }
    } catch (e) {
      return 'Registration error';
    }
  }

  Future<String?> _recoverPassword(String name) async {
    // optional, for forgot password
    return null;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: FlutterLogin(
          title: 'ECORP',
          onLogin: (data) => _authUser(data, context),
          onSignup: (data) => _signupUser(data, context),
          additionalSignupFields: [
    UserFormField(
      keyName: 'fullname',
      displayName: 'Full Name',
      icon: const Icon(Icons.person),
      fieldValidator: (value) {
        if (value == null || value.isEmpty) {
          return 'Full name required';
        }
        return null;
      },
    ),
  ],
          userType: LoginUserType.email, // force email mode

          onSubmitAnimationCompleted: () {
            if (context.mounted) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) =>
                      const WidgetTree(),
                ),
              );
            }
          },
          onRecoverPassword: (gmail) async {
            final Dio _dio = DioHandler.instance.dio;
            try {
              final response = await _dio.post(
                "/forgetPassword",
                data: {"email": gmail},
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
                if (context.mounted) {
                  Navigator.of(context).pushReplacement(
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => OtpScreen(gmail: gmail, isForResetPassword: true),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                }
                return null; // success
              } else if (response.data['status'] == false) {
                return "Error: ${response.data['message']}";
              }
            } on DioException catch (e) {
              if (e.response != null) {
                return ("Error: ${e.response?.statusCode} - ${e.response?.data}"); // ❌ 401, 404, 500, etc. → Dio throws → handled in catch (DioException).
              } else {
                print("Error: ${e.message}"); //network error
                return "error";
              }
            }
          },
        ),
      ),
    );
  }
}
