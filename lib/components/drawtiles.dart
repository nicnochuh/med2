import 'package:flutter/material.dart';

class listtile extends StatelessWidget {
  final IconData icon;
  final String text;
  final void Function()? onTap;
  const listtile(
      {super.key, required this.icon, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.white,
        ),
        onTap: onTap,
        title: Text(text),
        textColor: Colors.white,
      ),
    );
  }
}
