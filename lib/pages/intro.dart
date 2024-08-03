import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medtrack/auth/authent.dart';

class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  State<Intro> createState() => _introState();
}

class _introState extends State<Intro> {
  //show loading circle
  void reminderbox() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Authpage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: GestureDetector(
          onTap: reminderbox,
          child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              //logo
              Icon(
                Icons.medication_rounded,
                color: Colors.grey[700],
                size: 80,
              ),

              //title
              const SizedBox(height: 10),
              Text('MEDTRACK',
                  style: GoogleFonts.bebasNeue(
                      textStyle: const TextStyle(fontSize: 50))),
              const SizedBox(
                height: 10,
              ),
            ]),
          ),
        ));
  }

  icons(Icon icon) {}
}
