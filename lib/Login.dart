import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit03/HomeScreen.dart';
import 'package:habit03/Signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HabitTrackerLogin extends StatefulWidget {
  const HabitTrackerLogin({super.key});

  @override
  State<HabitTrackerLogin> createState() => _HabitTrackerLoginState();
}

class _HabitTrackerLoginState extends State<HabitTrackerLogin> {
  bool passwordVisible = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
    _checkLoginStatus(); // Check if user is already logged in
  }

  Future<void> _checkLoginStatus() async {
    // Check saved credentials in SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    String? savedEmail = prefs.getString('email');
    String? savedPassword = prefs.getString('password');

    if (savedEmail != null && savedPassword != null) {
      // Attempt to sign in with saved credentials
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: savedEmail, password: savedPassword);
        Get.offAll(Homescreen()); // Navigate to the HomeScreen directly
      } catch (e) {
        // Handle error if sign in fails
        print("Auto sign-in failed: $e");
      }
    }
  }

  Future<void> _login() async {
    String email = emailController.text.trim();
    String password = passController.text.trim();

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // Save email and password to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', email);
      await prefs.setString(
          'password', password); // Save the password (optional)

      Get.offAll(Homescreen()); // Navigate to the HomeScreen
      Get.snackbar("Success", "Welcome back!");
    } catch (e) {
      Get.snackbar("Login Failed",
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
                  "Login to your Habit Tracker",
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
                onPressed: _login,
                child: Text(
                  "Login",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Get.to(() => SignupPage());
              },
              child: Text("Don’t have an account? Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}
