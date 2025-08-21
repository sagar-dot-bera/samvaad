// ignore_for_file: prefer_const_constructors

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHandler {
  static FlutterLocalNotificationsPlugin localNotification =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const settings = AndroidInitializationSettings('app_icon');
    final initializeSettings = InitializationSettings(android: settings);

    await localNotification.initialize(initializeSettings);
  }

  static Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'my_foreground_service_channel', // Channel ID
      'Foreground Service', // Channel name
      description: 'This channel is used for foreground service notifications',
      importance: Importance.low,
      playSound: false,
    );

    await localNotification
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  // Method to show a notification
  static Future<void> showNotification(String title, String content) async {
    await localNotification.show(
      0, // Notification ID
      title, // Notification title
      content, // Notification content
      NotificationDetails(
        android: AndroidNotificationDetails(
          'my_foreground_service_channel', // Channel ID
          'Foreground Service', // Channel name
          channelDescription:
              'This channel is used for foreground service notifications',
          importance: Importance.low,
          priority: Priority.low,
        ),
      ),
    );
  }
}
