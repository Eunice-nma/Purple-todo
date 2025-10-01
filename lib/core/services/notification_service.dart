import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  static final notificationTitle = 'Porple Reminder';

  static Future<void> init() async {
    tz.initializeTimeZones();

    // Get device's local timezone
    try {
      final String timeZoneName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (e) {
      // fallback to Africa/Lagos
      tz.setLocalLocation(tz.getLocation('Africa/Lagos'));
    }

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosInit = DarwinInitializationSettings();
    const initSettings =
        InitializationSettings(android: androidInit, iOS: iosInit);

    await _notifications.initialize(initSettings);

    // Request permissions after initialization
    await _requestPermissions();
  }

  static Future<void> _requestPermissions() async {
    if (Platform.isAndroid) {
      // Request notification permission (Android 13+)
      final notificationStatus = await Permission.notification.status;
      if (notificationStatus.isDenied) {
        await Permission.notification.request();
      }

      // Request exact alarm permission (Android 12+)
      final alarmStatus = await Permission.scheduleExactAlarm.status;
      if (alarmStatus.isDenied) {
        await Permission.scheduleExactAlarm.request();
      }
    } else if (Platform.isIOS) {
      // Request iOS notification permissions
      await _notifications
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }
  }

  static Future<bool> hasPermissions() async {
    if (Platform.isAndroid) {
      final notification = await Permission.notification.isGranted;
      final alarm = await Permission.scheduleExactAlarm.isGranted;
      return notification && alarm;
    }
    return true;
  }

  static Future<String?> scheduleNotification({
    required int id,
    required String body,
    required TimeOfDay scheduledTime,
  }) async {
    if (!await hasPermissions()) {
      return 'Notification permissions not granted. Please enable them in settings.';
    }
    try {
      final now = DateTime.now();
      DateTime scheduledDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        scheduledTime.hour,
        scheduledTime.minute,
      );

      // If time has passed, return error
      if (scheduledDateTime.isBefore(now)) {
        return 'You can only set a future time today.';
      }

      await _notifications.zonedSchedule(
        id,
        notificationTitle,
        body,
        tz.TZDateTime.from(scheduledDateTime, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'todo_channel',
            'Todo Reminders',
            channelDescription: 'Reminders for your tasks',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );

      return null; // Success
    } catch (e) {
      print(e.toString());
      return 'Could not schedule reminder. Please check notification settings. ${e.toString()}';
    }
  }

  static Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }
}
