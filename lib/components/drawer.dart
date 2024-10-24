import 'package:flutter/material.dart';
import 'package:medtrack/components/drawtiles.dart';

class drawer extends StatelessWidget {
  final void Function()? onhometap;
  final void Function()? onprofiletap;
  final void Function()? signout;

  const drawer(
      {super.key,
      required this.onhometap,
      required this.onprofiletap,
      required this.signout});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Colors.grey[900],
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  //header
                  const DrawerHeader(
                      child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 60,
                  )),
                  const SizedBox(height: 50),
                  //
                  listtile(
                    icon: Icons.home,
                    text: 'H O M E',
                    onTap: onhometap,
                  ),

                  listtile(
                      icon: Icons.person_2,
                      text: 'P R O F I L E',
                      onTap: onprofiletap),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: listtile(
                    icon: Icons.logout, text: 'L O G  O U T', onTap: signout),
              ),
            ]));
  }
}
