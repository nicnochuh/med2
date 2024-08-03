import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:medtrack/components/notification_service.dart';
import 'package:medtrack/pages/Reminder.dart';
import 'package:medtrack/pages/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.android,
    );
    //  await NotificationService().init();

    runApp(const MyApp());
  } catch (e) {
    print("Error initializing app: $e");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Reminder(),
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