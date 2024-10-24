import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medtrack/components/mybutton.dart';
import 'package:medtrack/components/squaretile.dart';
import 'package:medtrack/components/textfield.dart';

class Login extends StatefulWidget {
  final Function()? ontap;
  const Login({super.key, required this.ontap});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //text editing controllers
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();

  //sign in
  void signuserin() async {
    //show loading circle
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));

//wrong password case
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailcontroller.text,
        password: passwordcontroller.text,
      );

      //end circle
      Navigator.pop(context);
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
        builder: (context) => AlertDialog(
                title: Text(
              message,
              style: const TextStyle(color: Colors.black),
            )));
  }

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
              const Icon(
                Icons.lock,
                size: 80,
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                'Login',
                style: TextStyle(fontSize: 18, color: Colors.grey[800]),
              ),
              const SizedBox(
                height: 20,
              ),

              //textfield username
              mytextfield(
                controller: emailcontroller,
                hintText: 'email',
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
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'forgot password?',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              //sign in button

              mybutton(text: "sign in", onTap: signuserin),

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
                    'Not a member?',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  GestureDetector(
                    onTap: widget.ontap,
                    child: const Text(
                      'Register now',
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
