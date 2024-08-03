import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medtrack/pages/homescreen.dart';
import 'package:medtrack/pages/loginorregister.dart';

class Authpage extends StatelessWidget {
  const Authpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              //logged in
              if (snapshot.hasData) {
                return const Homepage();
              }
              //not logged in
              else {
                return const Loginorregisterpage();
              }
            }));
  }
}
