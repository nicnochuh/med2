import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medtrack/components/user_data.dart';
import 'package:medtrack/components/userdetails.dart';

class Users extends StatefulWidget {
  const Users({super.key});

  @override
  State<Users> createState() => _UserState();
}

class _UserState extends State<Users> {
  // Current user
  final currentUser = FirebaseAuth.instance.currentUser!;
  // Users collection
  final usersCollection = FirebaseFirestore.instance.collection("users");

  // Edit field method
  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          "Edit $field",
          style: TextStyle(color: Colors.grey[300]),
        ),
        content: TextField(
            autofocus: true,
            style: TextStyle(color: Colors.grey[300]),
            decoration: InputDecoration(
              hintText: "Enter new $field",
              hintStyle: TextStyle(color: Colors.grey[300]),
            ),
            onChanged: (value) {
              newValue = value;
            }),
        actions: [
          // Cancel button
          TextButton(
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          // Save button
          TextButton(
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => Navigator.of(context).pop(newValue),
          ),
        ],
      ),
    );

    // Update Firestore and UserData if the new value is not empty
    if (newValue.trim().isNotEmpty) {
      await UserData.updateField(field, newValue);
      setState(() {}); // Refresh the UI to reflect changes
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 90),
          child: Text(
            'PROFILE',
            style: GoogleFonts.bebasNeue(
              textStyle: TextStyle(color: Colors.grey[300], fontSize: 40),
            ),
          ),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: usersCollection.doc(currentUser.email).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userdata = snapshot.data!.data() as Map<String, dynamic>;

            // Update UserData with the current user's data
            UserData.username = userdata['username'];
            UserData.emer = userdata['emer'];

            return ListView(
              children: [
                const SizedBox(height: 10),
                const Icon(
                  Icons.person,
                  size: 100,
                  color: Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 80),
                  child: Divider(
                    color: Colors.grey[600],
                    thickness: 1,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text('User Details',
                      style: TextStyle(color: Colors.grey[400], fontSize: 15)),
                ),
                Userbox(
                  text: userdata['username'],
                  sectionName: 'username',
                  onpressed: () => editField('username'),
                ),
                Userbox(
                  text: userdata['bio'],
                  sectionName: 'bio',
                  onpressed: () => editField('bio'),
                ),
                Userbox(
                  text: userdata['num'],
                  sectionName: 'phone',
                  onpressed: () => editField('num'),
                ),
                Userbox(
                  text: userdata['add'],
                  sectionName: 'address',
                  onpressed: () => editField('add'),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Medication Details',
                    style: TextStyle(color: Colors.grey[400], fontSize: 15),
                  ),
                ),
                Userbox(
                  text: userdata['blood'],
                  sectionName: 'blood type',
                  onpressed: () => editField('blood'),
                ),
                Userbox(
                  text: userdata['emer'],
                  sectionName: 'emergency number',
                  onpressed: () => editField('emer'),
                ),
                // Add any additional fields as necessary
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
