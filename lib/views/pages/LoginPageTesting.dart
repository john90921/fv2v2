import 'package:flutter/material.dart';
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

class LoginPageTesting extends StatefulWidget {
  const LoginPageTesting({super.key});

  @override
  State<LoginPageTesting> createState() => _LoginPageTestingState();
}

class _LoginPageTestingState extends State<LoginPageTesting> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  Future<String?> _authUser() async {
     if (_formKey.currentState!.validate()) {
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
        Map<String, dynamic> user = result.data["user"] as Map<String, dynamic>;
        Provider.of<Userprovider>(context, listen: false).login(user);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("login successfull")));

        if (!mounted) return null;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WidgetTree()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Invalid login: ${result.message}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("error")));
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
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Forgot password clicked'),
                          ),
                        );
                      },
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _authUser,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text("Login"),
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
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Register clicked')),
                          );
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
