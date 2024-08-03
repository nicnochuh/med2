import 'package:flutter/material.dart';
import 'package:medtrack/pages/login.dart';
import 'package:medtrack/pages/registerpage.dart';

class Loginorregisterpage extends StatefulWidget {
  const Loginorregisterpage({super.key});

  @override
  State<Loginorregisterpage> createState() => _LoginorregisterpageState();
}

class _LoginorregisterpageState extends State<Loginorregisterpage> {
  //show login page first

  bool showloginpage = true;

  //toggle between login and register page
  void togglepages() {
    setState(() {
      showloginpage = !showloginpage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showloginpage) {
      return Login(
        ontap: togglepages,
      );
    } else {
      return registerpage(
        ontap: togglepages,
      );
    }
  }
}
