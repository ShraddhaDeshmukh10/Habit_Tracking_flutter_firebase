import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit03/HomeScreen.dart';
import 'package:habit03/Signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habit03/controller/notification.dart'; // Import Notification Service
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
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
    _checkLoginStatus();
    _configureFirebaseMessaging();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedEmail = prefs.getString('email');
    String? savedPassword = prefs.getString('password');

    if (savedEmail != null && savedPassword != null) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: savedEmail, password: savedPassword);

        Get.offAll(Homescreen());

        // _notificationService.showNotification(
        //   'Hello',
        //   'Let\'s add new habits or work on them!',
        // );
        Get.snackbar("Success", "Welcome back!");
      } catch (e) {
        Get.snackbar("Login Failed",
            "Please check your email and password and try again.");
      }
    }
  }

  Future<void> _login() async {
    String email = emailController.text.trim();
    String password = passController.text.trim();

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', email);
      await prefs.setString('password', password);
      Get.offAll(Homescreen());
      // _notificationService.showNotification(
      //   'Hello',
      //   'Let\'s add new habits or work on them!',
      // );

      // String notificationTitle = 'Hello';
      // String notificationBody = 'Let\'s add new habits or work on them!';
      // Get.offAll(() => Homescreen(), arguments: {
      //   'title': notificationTitle,
      //   'body': notificationBody,
      // });

      Get.snackbar("Success", "Welcome back!");
    } catch (e) {
      Get.snackbar("Login Failed",
          "Please check your email and password and try again.");
    }
  }

  void _configureFirebaseMessaging() {
    // Foreground message handling
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        String? route =
            message.data['route']; // Extract the 'route' key from data
        if (route != null) {
          _notificationService.showForegroundNotification(message);
          // Navigate to the route passed in the notification data
          Get.toNamed(route);
        } else {
          _notificationService.showForegroundNotification(message);
        }
      }
    });

    // Handle notification when the app is in background and opened by a notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      String? route =
          message.data['route']; // Extract the 'route' key from data
      if (route != null) {
        Get.toNamed(route); // Navigate to the specified route
      }
    });
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
                onPressed: _login, // Trigger login function
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
