import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:habit03/HomeScreen.dart';
import 'package:habit03/Login.dart';
import 'package:habit03/controller/ThemeController.dart';
import 'package:habit03/controller/notification.dart';
import 'package:habit03/firebase_options.dart';
import 'package:get/get.dart';
import 'package:habit03/navi.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (message.data.containsKey('route')) {
    String route = message.data['route'];

    Get.toNamed(route);
  }
  print('Handling a background message: ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  final NotificationService _notificationService = NotificationService();
  await _notificationService.init();

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
    print('User denied permission');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize ThemeController
    final themeController = Get.put(ThemeController());

    return Obx(() => GetMaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          darkTheme: ThemeData.dark(),
          themeMode: themeController.isDarkTheme.value
              ? ThemeMode.dark
              : ThemeMode.light,
          initialRoute: '/',
          getPages: [
            GetPage(
              ///handle nav fun : innput as: rourte from firebase:::::
              name: '/',
              page: () => HabitTrackerLogin(),
            ),
            GetPage(
              name: '/homescreen',
              page: () => Homescreen(),
            ),
            GetPage(
              name: '/secondpage',
              page: () => Navigation0002(),
            ),
          ],
          //home: HabitTrackerLogin(),
          debugShowCheckedModeBanner: false,
        ));
  }
}
