import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Shared local notifications plugin instance
final FlutterLocalNotificationsPlugin localNotifications =
    FlutterLocalNotificationsPlugin();

/// Android notification channel for lab result notifications
const AndroidNotificationChannel resultChannel = AndroidNotificationChannel(
  'nexlab_results',
  'Test Results',
  description: 'Notifications when your lab results are ready',
  importance: Importance.high,
);
