import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

// Class names in Dart typically follow PascalCase (e.g., SignUpScreen)
class signUpScreen extends StatefulWidget {
  const signUpScreen({super.key});

  /// Sends a POST request to the API with the user's email and password.
  /// Note: Defining business logic inside the State class instead of the StatefulWidget
  /// allows direct access to the state lifecycle and context.
  void login(String email, String password) async {
    try {
      // Send HTTP POST request with form-encoded body
      Response response = await post(
        Uri.parse('https://reqres.in/api/register'),
        body: {
          'email': email,
          'password': password,
        },
      );

      // Check for HTTP 200 OK status
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print('Login successfully');
      } else {
        print('Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      // Catch network timeouts, connection errors, or malformed URIs
      print('Error during network call: ${e.toString()}');
    }
  }

  @override
  State<signUpScreen> createState() => _signUpScreenState();
}

class _signUpScreenState extends State<signUpScreen> {
  // Controllers to listen to and retrieve input text from fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Dispose controllers when the widget is removed from the widget tree to prevent memory leaks
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text("Sign Up API"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Email Input Field
            // Note: SingleChildScrollView is typically used around the Column or Scaffold body
            // to avoid keyboard overflow rather than wrapping an individual TextFormField.
            SingleChildScrollView(
              child: TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress, // Optimizes keyboard layout for email input
                decoration: const InputDecoration(
                  hintText: 'Email',
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),

            // Password Input Field
            TextFormField(
              controller: passwordController,
              obscureText: true, // Masks the text for password security
              decoration: const InputDecoration(
                hintText: 'Password',
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            // Custom Submit Button
            GestureDetector(
              onTap: () {
                // Read text values from controllers and trigger the network call
                widget.login(
                  emailController.text.trim(),
                  passwordController.text.trim(),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 40,
                child: const Center(
                  child: Text(
                    "Sign up",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}