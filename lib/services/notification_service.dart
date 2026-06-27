import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {

  final FlutterLocalNotificationsPlugin
  flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> init() async {

    const AndroidInitializationSettings
    androidInitializationSettings =
    AndroidInitializationSettings(
        '@mipmap/ic_launcher');

    const InitializationSettings
    initializationSettings =
    InitializationSettings(
        android: androidInitializationSettings);

    await flutterLocalNotificationsPlugin
        .initialize(initializationSettings);
  }

  Future<void> showNotification(
      String title,
      String body) async {

    const AndroidNotificationDetails
    androidNotificationDetails =
    AndroidNotificationDetails(
      "channel_id",
      "CCMS Notifications",
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails
    notificationDetails =
    NotificationDetails(
      android: androidNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }
}
