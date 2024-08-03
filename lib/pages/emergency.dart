import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medtrack/components/user_data.dart';
import 'package:medtrack/pages/alertpage.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LoadingButton extends StatefulWidget {
  const LoadingButton({super.key});

  @override
  LoadingButtonState createState() => LoadingButtonState();
}

class LoadingButtonState extends State<LoadingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    controller.addListener(() {
      setState(() {});
    });
  }

  void _sendSMS() async {
    String message = "${UserData.username} is in DANGER, Help!";
    String smsUri;

    if (UserData.emer.isNotEmpty) {
      smsUri = "sms:${UserData.emer}?body=${Uri.encodeComponent(message)}";
    } else {
      smsUri =
          "sms:?body=${Uri.encodeComponent(message)}"; // No number, user will be prompted to select a contact
    }

    if (await canLaunchUrl(Uri.parse(smsUri))) {
      await launchUrlString(smsUri);
    } else {
      throw 'Could not send SMS';
    }
  }

  void alertpage() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AlertPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // This will rebuild the widget when UserData changes
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
      ),
      backgroundColor: Colors.grey[300],
      body: Column(
        children: [
          const SizedBox(height: 100),
          const Text('Hold in case of'),
          Text('EMERGENCY',
              style: GoogleFonts.bebasNeue(
                  textStyle: const TextStyle(fontSize: 30))),
          const SizedBox(height: 30),
          Center(
            child: GestureDetector(
              onTapDown: (_) => controller.forward(),
              onTapUp: (_) {
                if (controller.status == AnimationStatus.forward) {
                  controller.reverse();
                } else if (controller.status == AnimationStatus.completed) {
                  _sendSMS();
                  alertpage();
                }
              },
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  const CircularProgressIndicator(
                    value: 9.0,
                    strokeWidth: 20,
                    strokeAlign: 12,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Color.fromARGB(255, 224, 224, 224)),
                  ),
                  CircularProgressIndicator(
                    value: controller.value,
                    strokeAlign: 12,
                    strokeWidth: 20,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(80),
                      child: Image.asset(
                        "lib/icons/emergency.png",
                        height: 100,
                        color: Colors.grey[850],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 50),
          const Text('Release to cancel')
        ],
      ),
    );
  }
}
