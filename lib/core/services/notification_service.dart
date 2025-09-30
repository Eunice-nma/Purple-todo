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

// old
//   static Future<void> init() async {
//     try {
//       // Initialize timezones
//       tz.initializeTimeZones();
//       // Set local timezone (CRITICAL FIX)
//       tz.setLocalLocation(tz.getLocation(
//           'Africa/Lagos')); // Or use flutter_native_timezone package

//       const AndroidInitializationSettings androidInit =
//           AndroidInitializationSettings('@mipmap/ic_launcher');

//       const DarwinInitializationSettings iosInit = DarwinInitializationSettings(
//         requestAlertPermission: true,
//         requestBadgePermission: true,
//         requestSoundPermission: true,
//       );

//       const InitializationSettings initSettings = InitializationSettings(
//         android: androidInit,
//         iOS: iosInit,
//       );

//       await _notifications.initialize(initSettings);

// // Request notification permission
//       if (await Permission.notification.isDenied) {
//         await Permission.notification.request();
//       }
//     } catch (e) {
//       print('Error initializing notifications: $e');
//     }
//   }

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

// sorta new
//   static Future<void> init() async {
//     tz.initializeTimeZones();
//     // try {
// // Get device's local timezone using flutter_timezone
//     // final String timeZoneName = await FlutterTimezone.getLocalTimezone();
//     //   tz.setLocalLocation(tz.getLocation(timeZoneName));
//     // } catch (e) {
//     // fallback to Africa/Lagos
//     tz.setLocalLocation(tz.getLocation('Africa/Lagos'));
//     // }

//     const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
//     const DarwinInitializationSettings iosInit = DarwinInitializationSettings();
//     const initSettings =
//         InitializationSettings(android: androidInit, iOS: iosInit);

//     await _notifications.initialize(initSettings);

  // request permissions (Android 13+ and iOS)
  // if (await Permission.notification.isDenied) {
  //   await Permission.notification.request();
  // }

  // await _notifications
  //     .resolvePlatformSpecificImplementation<
  //         IOSFlutterLocalNotificationsPlugin>()
  //     ?.requestPermissions(
  //       alert: true,
  //       badge: true,
  //       sound: true,
  //     );
  // }
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

  static Future<void> showInstantNotification({
    required String title,
    required String body,
    required int id, // Allow custom ID
  }) async {
    try {
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'todo_channel',
        'Todo Reminders',
        channelDescription: 'Reminders for your tasks',
        importance: Importance.max,
        priority: Priority.high,
      );

      const NotificationDetails details =
          NotificationDetails(android: androidDetails);

      await _notifications.show(id, title, body, details);
    } catch (e) {
      print('Error showing notification: $e');
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

  static Future<void> testNowNotification() async {
    if (!await hasPermissions()) {
      print(
          ':::::::::::::::::Notification permissions not granted. Please enable them in settings.');
    }
    final scheduledDate = DateTime.now().add(const Duration(seconds: 15));
    await _notifications.zonedSchedule(
      100,
      "Scheduled Test",
      "This should appear 20 seconds later",
      tz.TZDateTime.from(scheduledDate, tz.local),
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

  // static Future<void> scheduleNotification({
  //   required int id,
  //   required String title,
  //   required String body,
  //   required TimeOfDay scheduledTime,
  // }) async {
  //   try {
  //     final now = DateTime.now();

  //     // Combine today's date with the TimeOfDay
  //     DateTime scheduledDateTime = DateTime(
  //       now.year,
  //       now.month,
  //       now.day,
  //       scheduledTime.hour,
  //       scheduledTime.minute,
  //     );

  //     // If that time has already passed today, schedule it for tomorrow
  //     if (scheduledDateTime.isBefore(now)) {
  //       scheduledDateTime = scheduledDateTime.add(const Duration(minutes: 1));
  //     }

  //     await _notifications.zonedSchedule(
  //       id,
  //       title,
  //       body,
  //       tz.TZDateTime.from(scheduledDateTime, tz.local),
  //       const NotificationDetails(
  //         android: AndroidNotificationDetails(
  //           'todo_channel',
  //           'Todo Reminders',
  //           channelDescription: 'Reminders for your tasks',
  //           importance: Importance.max,
  //           priority: Priority.high,
  //         ),
  //       ),
  //       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  //     );
  //   } catch (e) {
  //     print('Error scheduling notification: $e');
  //   }
  // }

  static Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }
}
