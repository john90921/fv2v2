import 'package:flutter/material.dart';
import 'package:fv2/api/ApiHelper.dart';
import 'package:fv2/providers/UserProvider.dart';
import 'package:fv2/token/TokenManager.dart';
import 'package:fv2/views/WidgetTree.dart';
import 'package:fv2/views/pages/OtpScreen.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:fv2/services/HuaweiAuthService.dart';

//sorvictor90@gmail.com
class LoginPageTesting extends StatefulWidget {
  const LoginPageTesting({super.key});

  @override
  State<LoginPageTesting> createState() => _LoginPageTestingState();
}

class _LoginPageTestingState extends State<LoginPageTesting> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final HuaweiAuthService _huaweiAuthService = HuaweiAuthService();

  Future<void> _authUser(BuildContext context) async {
    bool statusLogin = false;
    String message = "";
    if (_formKey.currentState!.validate()) {
      context.loaderOverlay.show();
      try {
        ApiResult result = await Apihelper.post(
          ApiRequest(
            path: "/login",
            data: {
              "email": _emailController.text,
              "password": _passwordController.text,
            },
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
          Map<String, dynamic> user =
              result.data["user"] as Map<String, dynamic>;
          Provider.of<Userprovider>(context, listen: false).login(user);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("login successfull")));
          statusLogin = true;
          message = "success";
        } else {
          if (result.message == "unverified") {
            message = result.message;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Account unverified, redirecting to OTP screen"),
              ),
            );
          } else {
            print("login error: ${result.message}");
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("invalid credentials")));
          }
        }
      } catch (e) {
        print("login error: $e");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Login error: $e")));
      }
      context.loaderOverlay.hide();
      if (statusLogin) {
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const WidgetTree()),
          (Route<dynamic> route) => false,
        );
      } else if (!statusLogin) {
        if (message == "unverified") {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Account unverified, redirecting to OTP screen"),
            ),
          );
          String gmail = _emailController.text;
          if (context.mounted) {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (_, __, ___) =>
                    OtpScreen(gmail: gmail, isForResetPassword: false),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          }
        }
      }
    }
  }

  /// Login with Huawei ID
  Future<void> _loginWithHuaweiId() async {
    try {
      context.loaderOverlay.show();

      // Sign in with Huawei
      final huaweiUserData = await _huaweiAuthService.signIn();

      if (huaweiUserData != null) {
        // Send Huawei ID token to your backend for verification and authentication
        try {
          ApiResult result = await Apihelper.post(
            ApiRequest(
              path: "/huawei-login",
              data: {
                "idToken": huaweiUserData['idToken'],
                "email": huaweiUserData['email'],
                "displayName": huaweiUserData['displayName'],
                "openId": huaweiUserData['openId'],
                "unionId": huaweiUserData['unionId'],
                "avatarUri": huaweiUserData['avatarUri'],
              },
            ),
          );

          if (result.status == true) {
            final token = result.data["token"];
            if (token != null) {
              await TokenManager.instance.saveAccessToken(token);
            }

            print("Huawei login successful");
            print("user data: ${result.data}");

            Map<String, dynamic> user =
                result.data["user"] as Map<String, dynamic>;
            Provider.of<Userprovider>(context, listen: false).login(user);

            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Huawei login successful")));

            if (!mounted) return;
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const WidgetTree()),
              (Route<dynamic> route) => false,
            );
          } else {
            print("Backend authentication failed: ${result.message}");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Authentication failed: ${result.message}"),
              ),
            );
          }
        } catch (e) {
          print("Backend authentication error: $e");
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Authentication error: $e")));
        }
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Huawei sign in cancelled")));
      }
    } catch (e) {
      print("Huawei login error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Huawei login error: $e")));
    } finally {
      if (mounted) {
        context.loaderOverlay.hide();
      }
    }
  }

  // void _login() {
  //   if (_formKey.currentState!.validate()) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(
  //           'Email: ${_emailController.text}, Password: ${_passwordController.text}',
  //         ),
  //       ),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Login",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 40),

                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      }
                      final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                      if (!emailRegExp.hasMatch(value)) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 10),

                  // Forgot Password
                  // Align(
                  //   alignment: Alignment.centerRight,
                  //   child: TextButton(
                  //     onPressed: () {
                  //       Navigator.pushNamed(context, '/requestResetPage');
                  //     },
                  //     child: const Text(
                  //       "Forgot Password?",
                  //       style: TextStyle(color: Colors.blueAccent),
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 20),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _authUser(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text("Login"),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Divider with "OR"
                  Row(
                    children: [
                      Expanded(child: Divider(thickness: 1)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          "OR",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(thickness: 1)),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Huawei ID Login Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _loginWithHuaweiId,
                      icon: Icon(Icons.phone_android, color: Colors.red[700]),
                      label: const Text(
                        "Login with Huawei ID",
                        style: TextStyle(color: Colors.black87),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: Colors.grey[400]!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Register Option
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/registerPage');
                        },
                        child: const Text(
                          "Register",
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                      ),
                    ],
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
