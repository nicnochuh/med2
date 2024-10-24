import 'package:firebase_core/firebase_core.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medtrack/components/notification_service.dart';
import 'package:medtrack/pages/firebase_options.dart';
import 'package:medtrack/pages/intro.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();
  await NotificationService().init();
  await requestNotificationPermission();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.android,
    );

    runApp(const MyApp());
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
}

Future<void> requestNotificationPermission() async {
  if (await Permission.notification.request().isGranted) {
    print('Notification permission granted');
  } else {
    print('Notification permission denied');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Intro(),
    );
  }
}


/*
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:med/components/Notif.dart';
import 'package:med/pages/intro.dart';
import 'firebase_options.dart';

// ...

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.android,
  );
  await FirebaseApi().initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Intro(),
    );
  }
}
*/