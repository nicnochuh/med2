import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('notifclock');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'medtrack_channel', // id
      'Medication Reminders', // title
      description: 'Daily medication reminders',
      importance: Importance.max,
    );
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> scheduleDailyNotification(
      DateTime dateTime, int id, String title, String body) async {
    final tz.TZDateTime scheduledDate = tz.TZDateTime.from(dateTime, tz.local);
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'medtrack_channel',
      'your_channel_name',
      channelDescription: 'Your channel description',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id, // Notification ID
      title, // Notification title
      body, // Notification body
      scheduledDate, // Schedule time
      platformDetails,
      androidScheduleMode: AndroidScheduleMode
          .exactAllowWhileIdle, // To show even when device is idle
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
      matchDateTimeComponents:
          DateTimeComponents.dateAndTime, // Optional matching
    );
  }
/* Future<void> scheduleDailyNotification(int id, String title, String body,
      TimeOfDay time, DateTime endDate) async {
    print('Scheduling notification at: ${_nextInstanceOfTime(time, endDate)}');

    await _flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        _nextInstanceOfTime(time, endDate),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'medtrack_channel', // Channel ID
            'Medication Reminders', // Channel name
            channelDescription: 'Daily medication reminders',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }
  
*/
  /*  Future<void> scheduleZonedNotification() async {
      // Define the time when the notification should trigger
      final tz.TZDateTime scheduledDate = tz.TZDateTime.now(tz.local).add(
        const Duration(seconds: 5), // 5 seconds from now
      );
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        0, // Notification ID
        'Reminder', // Notification title
        'It\'s time to take a break!', // Notification body
        scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'your_channel_id', // Channel ID
            'your_channel_name', // Channel name
            channelDescription: 'Your channel description',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: true,
          ),
        ),
        // Show even when the device is idle
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time, // Optional
      );
    }
*/
  /*  Future<void> showInstantNotification() async {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'your_channel_id', // Channel ID
        'your_channel_name', // Channel name
        channelDescription: 'Your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
      );
*/

  /* const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      await _flutterLocalNotificationsPlugin.show(
        0, // Notification ID
        'Hello!', // Notification title
        'This is an instant notification.', // Notification body
        platformChannelSpecifics,
        payload: 'Default_Sound', // Optional payload
      );
    }
*/
  Future<void> cancelNotification(int id) async {
    try {
      await _flutterLocalNotificationsPlugin.cancel(id);
    } catch (e) {
      print('Error canceling notification: $e');
    }
  }

  tz.TZDateTime _nextInstanceOfTime(TimeOfDay time, DateTime endDate) {
    tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    // If the scheduled date is before now or after the end date, schedule for tomorrow
    if (scheduledDate.isBefore(now) ||
        scheduledDate.isAfter(tz.TZDateTime.from(endDate, tz.local))) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }
}
