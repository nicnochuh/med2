/*import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  //instance of firebase messaging
  final _firebasemessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    //request persmission from the user
    await _firebasemessaging.requestPermission();

    //fetch the fcm token for this device
    final fCMToken = await _firebasemessaging.getToken();

    //print the token(send to server in normal cases)
    print('Token: $fCMToken');
  }

  //handling messages

  void handleMessages(RemoteMessage? message) {
    //if message null
    if (message == null) return;
  }

  //initialize background settings
  Future initPushNotifications() async {
    //handle notifications if the app was terminated and now opened
    FirebaseMessaging.instance.getInitialMessage().then(handleMessages);
  }
}
*/
//-----------------
/* import 'package:flutter/material.dart';


import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReminderPage extends StatefulWidget {
  const ReminderPage({super.key});

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class Model {
  final String id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final TimeOfDay time;

  const Model({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'time': '${time.hour}:${time.minute}',
    };
  }

  static Model fromMap(String id, Map<String, dynamic> map) {
    return Model(
      id: id,
      name: map['name'],
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      time: TimeOfDay(
        hour: int.parse(map['time'].split(':')[0]),
        minute: int.parse(map['time'].split(':')[1]),
      ),
    );
  }
}

class _ReminderPageState extends State<ReminderPage> {
  final TextEditingController medNameController = TextEditingController();
  TimeOfDay _timeOfDay = TimeOfDay.now();
  DateTime _endDate = DateTime.now();
  final double horizontalPadding = 25;
  final List<Model> _reminderList = [];

  @override
  void initState() {
    super.initState();
    _fetchReminders();
  }

  void showTimePickerDialog() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      if (value != null) {
        setState(() {
          _timeOfDay = value;
        });
      }
    });
  }

  void showDatePickerDialog() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    ).then((value) {
      if (value != null) {
        setState(() {
          _endDate = value;
        });
      }
    });
  }

  Future<void> _fetchReminders() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('reminders').get();
    setState(() {
      _reminderList.clear();
      for (var doc in snapshot.docs) {
        _reminderList
            .add(Model.fromMap(doc.id, doc.data() as Map<String, dynamic>));
      }
    });
  }

  Future<void> _addReminder() async {
    Model newReminder = Model(
      id: '',
      name: medNameController.text,
      startDate: DateTime.now(),
      endDate: _endDate,
      time: _timeOfDay,
    );

    DocumentReference docRef = await FirebaseFirestore.instance
        .collection('reminders')
        .add(newReminder.toMap());

    setState(() {
      _reminderList.insert(
          0,
          newReminder.copyWith(
              id: docRef.id)); // Insert at the start of the list
    });

    medNameController.clear();
  }

  Future<void> _deleteReminder(String id, int index) async {
    await FirebaseFirestore.instance.collection('reminders').doc(id).delete();
    setState(() {
      _reminderList.removeAt(index);
    });
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reminders',
              style: GoogleFonts.bebasNeue(
                textStyle: TextStyle(fontSize: 55, color: Colors.grey[800]),
              ),
            ),
            TextField(
              controller: medNameController,
              decoration: InputDecoration(
                hintText: 'Enter med name',
                hintStyle: TextStyle(color: Colors.grey[800]),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Time: ${_timeOfDay.format(context)}',
                  style: GoogleFonts.bebasNeue(
                    textStyle: TextStyle(fontSize: 25, color: Colors.grey[800]),
                  ),
                ),
                MaterialButton(
                  onPressed: showTimePickerDialog,
                  color: Colors.grey[200],
                  child: Text(
                    'PICK TIME',
                    style: TextStyle(color: Colors.grey[700], fontSize: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'End Date: ${_formatDate(_endDate)}',
                  style: GoogleFonts.bebasNeue(
                    textStyle: TextStyle(fontSize: 25, color: Colors.grey[800]),
                  ),
                ),
                MaterialButton(
                  onPressed: showDatePickerDialog,
                  color: Colors.grey[200],
                  child: Text(
                    'PICK DATE',
                    style: TextStyle(color: Colors.grey[700], fontSize: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.grey[200],
                    backgroundColor: Colors.grey[300],
                    elevation: 3),
                onPressed: _addReminder,
                child: Text(
                  'Add Reminder',
                  style: GoogleFonts.bebasNeue(
                    textStyle: TextStyle(fontSize: 25, color: Colors.grey[800]),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Divider(color: Colors.grey[400], thickness: 0.8),
            const SizedBox(height: 10),
            Text(
              'Current Reminders',
              style: TextStyle(color: Colors.grey[700], fontSize: 25),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _reminderList.length,
                itemBuilder: (context, index) {
                  final reminder = _reminderList[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              reminder.name,
                              style: GoogleFonts.bebasNeue(
                                textStyle: TextStyle(
                                    fontSize: 25, color: Colors.grey[800]),
                              ),
                            ),
                            Text(
                              'Time: ${reminder.time.format(context)}',
                              style: TextStyle(
                                  fontSize: 18, color: Colors.grey[800]),
                            ),
                            Text(
                              'Until: ${_formatDate(reminder.endDate)}',
                              style: TextStyle(
                                  fontSize: 18, color: Colors.grey[800]),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteReminder(reminder.id, index),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension on Model {
  Model copyWith(
      {String? id,
      String? name,
      DateTime? startDate,
      DateTime? endDate,
      TimeOfDay? time}) {
    return Model(
      id: id ?? this.id,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      time: time ?? this.time,
    );
  }
}
*/