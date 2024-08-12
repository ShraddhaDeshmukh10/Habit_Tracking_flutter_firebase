import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit03/HomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool passwordVisible = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
  }

  Future<void> _signup() async {
    String email = emailController.text.trim();
    String password = passController.text.trim();

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      Get.offAll(
          Homescreen()); // Navigate to the HomeScreen after successful signup
      Get.snackbar("Success", "Account created successfully!");
    } catch (e) {
      Get.snackbar("Signup Failed",
          "Please check your email and password and try again.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: NetworkImage(
        //         "https://your-background-image-url-here"), // Replace with an appropriate background image URL
        //     fit: BoxFit.cover,
        //   ),
        // ),
        margin: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 0.8 * w,
              height: 0.1 * h,
              margin: EdgeInsets.all(10),
              child: Center(
                child: Text(
                  "Create a New Account",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              width: 0.8 * w,
              height: 0.1 * h,
              margin: EdgeInsets.all(10),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(CupertinoIcons.mail),
                  hintText: "Your Email",
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            Container(
              width: 0.8 * w,
              height: 0.1 * h,
              margin: EdgeInsets.all(10),
              child: TextField(
                controller: passController,
                obscureText: passwordVisible,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(CupertinoIcons.lock),
                  hintText: "Your Password",
                  suffixIcon: IconButton(
                    icon: Icon(passwordVisible
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        passwordVisible = !passwordVisible;
                      });
                    },
                  ),
                ),
              ),
            ),
            Container(
              width: 0.8 * w,
              height: 0.07 * h,
              margin: EdgeInsets.only(top: 20),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blueAccent),
                ),
                onPressed: _signup,
                child: Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate back to the login page
                Get.back();
              },
              child: Text("Already have an account? Login"),
            ),
          ],
        ),
      ),
    );
  }
}
