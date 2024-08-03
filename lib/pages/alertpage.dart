import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AlertPage extends StatelessWidget {
  const AlertPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              'lib/icons/emergency.png',
              height: 50,
            ),
          ),
          Text("ALERT SEND",
              style: GoogleFonts.bebasNeue(
                  textStyle: const TextStyle(fontSize: 50, color: Colors.red))),
        ],
      ),
    );
  }
}
