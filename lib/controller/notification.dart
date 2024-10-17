import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:workmanager/workmanager.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _notificationsPlugin.initialize(initializationSettings);

    // Setup Firebase Messaging for foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showForegroundNotification(message);
    });

    Workmanager().registerPeriodicTask(
      "1",
      "simplePeriodicTask",
      frequency: Duration(minutes: 1), // Set frequency to 1 minute
      initialDelay: Duration(seconds: 10), // Optional initial delay
    );
  }

  Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'habit_tracker_channel_id',
      'Habit Tracker Channel',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await _notificationsPlugin.show(0, title, body, platformChannelSpecifics);
  }

  Future<void> showForegroundNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'habit_tracker_channel_id',
      'Habit Tracker Channel',
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound('new_music'),
      playSound: true,
      ticker: 'ticker',
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notificationsPlugin.show(
      0, // Notification ID (unique)
      message.notification?.title ?? 'Title', // Fallback to "Title"
      message.notification?.body ?? 'Body', // Fallback to "Body"
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }
}
