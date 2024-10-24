import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medtrack/components/drawer.dart';
import 'package:medtrack/pages/emergency.dart';
import 'package:medtrack/pages/reminderPage.dart';
import 'package:medtrack/pages/user.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  //user
  final currentuser = FirebaseAuth.instance.currentUser!;
  //operationbox

  void reminderbox() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ReminderPage(),
      ),
    );
  }

  ///emergency
  void emergencybox() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoadingButton(),
      ),
    );
  }

  //signout
  void signuserout() {
    FirebaseAuth.instance.signOut();
  }

  final double horizontalpadding = 35;

  final double verticalpadding = 10;

  //go to user page
  void gotouserpage() {
    //pop menu drawer
    Navigator.pop(context);
    //go to user profile
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Users()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
      ),
      backgroundColor: Colors.grey[300],
      drawer: drawer(
        onTap: () => Navigator.pop(context),
        onprofiletap: gotouserpage,
        signout: signuserout,
      ),
      /* bottomNavigationBar: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
          child: GNav(
            backgroundColor: Colors.black,
            color: Colors.white,
            tabBackgroundColor: Colors.grey.shade800,
            activeColor: Colors.grey,
            gap: 10,
            padding: const EdgeInsets.all(10),
            tabs: [
              GButton(
                icon: Icons.home,
                text: 'home',
              ),
              GButton(
                icon: Icons.add_alert,
                text: 'emergency',
                textColor: Colors.red,
                iconActiveColor: Colors.red,
              ),
              GButton(
                icon: Icons.person,
                text: 'profile',
              ),
            ],
          ),
        ),
      ),  */
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalpadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('welcome to,'),
                  Text('MEDTRACK',
                      style: GoogleFonts.bebasNeue(
                          textStyle: const TextStyle(fontSize: 60))),
                ],
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalpadding),
              child: Divider(
                color: Colors.grey[400],
                thickness: 1,
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalpadding),
              child: Text(
                'operations',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            GestureDetector(
              onTap: reminderbox,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalpadding),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 150.0),
                        child: Image.asset(
                          "lib/icons/clock.png",
                          height: 45,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "reminders",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: emergencybox,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalpadding),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20)),
                  child: const Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: Icon(
                          Icons.add_alert,
                          size: 45,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "EMERGENCY",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            //operationsbox
            /*   const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: operationbox(
                operation: 'operation',
                iconpath:,
                select: true,
                // onTap: reminder;
              ),
            )
            */
          ],
        ),
      ),
    );
  }
}
