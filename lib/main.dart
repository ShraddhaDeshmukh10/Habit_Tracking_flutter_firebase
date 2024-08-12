import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:habit03/Login.dart';
import 'package:habit03/controller/ThemeController.dart';
import 'package:habit03/firebase_options.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize ThemeController
    final themeController = Get.put(ThemeController());

    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(), // Define dark theme
      themeMode:
          themeController.isDarkTheme.value ? ThemeMode.dark : ThemeMode.light,
      home: HabitTrackerLogin(),
      debugShowCheckedModeBanner: false,
    );
  }
}
