import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medtrack/components/mybutton.dart';
import 'package:medtrack/components/squaretile.dart';
import 'package:medtrack/components/textfield.dart';

class registerpage extends StatefulWidget {
  final Function()? ontap;
  const registerpage({super.key, required this.ontap});

  @override
  State<registerpage> createState() => _registerpageState();
}

class _registerpageState extends State<registerpage> {
  //text editing controllers
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final confirmpasswordcontroller = TextEditingController();

  //sign in
  void signuserup() async {
    //show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

//wrong password case

    //check if password is confirmed
    if (passwordcontroller.text != confirmpasswordcontroller.text)
    //pop leading circle
    {
      Navigator.pop(context);

      //show error message passwords don't match
      showerrormessage("Passwords don't match");
      return;
    }
    //try create the user

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailcontroller.text,
        password: passwordcontroller.text,
      );

      // after user creation, create a new document in firestore database called users

      FirebaseFirestore.instance
          .collection("users")
          .doc(userCredential.user!.email)
          .set({
        //username
        'username': emailcontroller.text.split('@')[0],
        //initially empty bio
        'bio': 'not set',
        'num': 'not set',
        'add': 'not set',
        'blood': 'not set',
        'emer': 'not set'
      });

      //end circle
      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      //end circle
      Navigator.pop(context);

      //show error message
      showerrormessage(e.code);
    }
  }

  //error message
  void showerrormessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        );
      },
    );
  }
  //main

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
            child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              //logo
              const Icon(
                Icons.person,
                size: 80,
              ),

              const SizedBox(
                height: 30,
              ),
              Text(
                'let\'s create an account for you',
                style: TextStyle(fontSize: 18, color: Colors.grey[800]),
              ),
              const SizedBox(
                height: 20,
              ),

              //textfield username
              mytextfield(
                controller: emailcontroller,
                hintText: 'email id',
                obscureText: false,
              ),

              const SizedBox(
                height: 20,
              ),
              //textfield username
              mytextfield(
                controller: passwordcontroller,
                hintText: 'password',
                obscureText: true,
              ),

              const SizedBox(
                height: 20,
              ),
              //confirm password
              mytextfield(
                controller: confirmpasswordcontroller,
                hintText: 'confirm password',
                obscureText: true,
              ),
              const SizedBox(
                height: 20,
              ),

              //sign up button

              mybutton(text: "sign up", onTap: signuserup),

              const SizedBox(height: 50),

              //continue with

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  children: [
                    Expanded(
                        child: Divider(
                      thickness: 0.5,
                      color: Colors.grey[400],
                    )),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text("or continue with",
                          style: TextStyle(color: Colors.grey[700])),
                    ),
                    Expanded(
                        child: Divider(
                      thickness: 0.5,
                      color: Colors.grey[400],
                    ))
                  ],
                ),
              ),

              const SizedBox(height: 35),
              //google button
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [squaretile(imagepath: 'lib/icons/google.png')],
              ),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'already a member?',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  GestureDetector(
                    onTap: widget.ontap,
                    child: const Text(
                      'login now',
                      style: TextStyle(color: Colors.blue),
                    ),
                  )
                ],
              ),
            ],
          ),
        )),
      ),
    );
  }
}
