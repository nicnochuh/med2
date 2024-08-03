import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medtrack/components/allReminders.dart';
import 'package:medtrack/components/drawer.dart';
import 'package:medtrack/components/models.dart';
import 'package:medtrack/components/notification_service.dart';
import 'package:medtrack/pages/constants.dart';
import 'package:medtrack/pages/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Reminder extends StatefulWidget {
  const Reminder({super.key});

  @override
  _ReminderState createState() => _ReminderState();
}

class _ReminderState extends State<Reminder> {
  final TextEditingController medNameController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  DateTime _endDate = DateTime.now();
  List<TimeOfDay> _selectedTimes = [];
  final List<Model> _reminderList = [];
  bool morning = false;
  bool afternoon = false;
  bool night = false;
  int? _expandedIndex;

  @override
  void initState() {
    super.initState();
    _fetchReminders();
  }

  // Sign out
  void signuserout() {
    FirebaseAuth.instance.signOut();
  }

  // Go to user page
  void gotouserpage() {
    Navigator.pop(context); // Pop menu drawer
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Users()),
    );
  }

  // Fetch reminders from Firestore
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

  // Add reminder to Firestore
  Future<void> _addReminder() async {
    if (medNameController.text.isEmpty || _selectedTimes.isEmpty) return;

    Model newReminder = Model(
      id: '',
      name: medNameController.text,
      startDate: DateTime.now(),
      endDate: _endDate,
      times: _selectedTimes,
      notes: notesController.text,
    );

    DocumentReference docRef = await FirebaseFirestore.instance
        .collection('reminders')
        .add(newReminder.toMap());

    setState(() {
      _reminderList.insert(
        0,
        newReminder.copyWith(id: docRef.id),
      );
      morning = false;
      afternoon = false;
      night = false;
      _selectedTimes.clear();
    });

    // Schedule notifications for each selected time
    for (var time in newReminder.times) {
      await NotificationService().scheduleDailyNotification(
        newReminder.hashCode + time.hashCode,
        'Reminder: ${newReminder.name}',
        'It\'s time for ${newReminder.name}',
        time,
        newReminder.endDate,
      );
    }

    medNameController.clear();
    notesController.clear();
  }

  // Delete reminder from Firestore and cancel notifications
  Future<void> _deleteReminder(String id, int index) async {
    await FirebaseFirestore.instance.collection('reminders').doc(id).delete();
    final reminder = _reminderList[index];
    for (var time in reminder.times) {
      await NotificationService()
          .cancelNotification(reminder.hashCode + time.hashCode);
    }
    setState(() {
      _reminderList.removeAt(index);
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

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kPrimary,
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
      ),
      drawer: drawer(
        onTap: () => Navigator.pop(context),
        onprofiletap: gotouserpage,
        signout: signuserout,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'REMINDERS',
                style: GoogleFonts.bebasNeue(
                  textStyle: TextStyle(fontSize: 50, color: Colors.grey[800]),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: kSecondary,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(255, 173, 173, 173),
                      blurRadius: 10,
                      offset: Offset(2, 3),
                    ),
                  ],
                ),
                child: TextField(
                  controller: medNameController,
                  style: TextStyle(
                    color: kTextPrimary,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter medicine name',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'When to take?',
                style: TextStyle(
                  color: kTextPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        morning = !morning;
                        if (morning) {
                          _selectedTimes
                              .add(const TimeOfDay(hour: 8, minute: 0));
                        } else {
                          _selectedTimes.removeWhere(
                              (time) => time.hour == 7 && time.minute == 30);
                        }
                      });
                    },
                    child: TimeCard(
                      icon: CupertinoIcons.sunrise,
                      time: 'Morning',
                      isSelected: morning,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        afternoon = !afternoon;
                        if (afternoon) {
                          _selectedTimes
                              .add(const TimeOfDay(hour: 12, minute: 30));
                        } else {
                          _selectedTimes.removeWhere(
                              (time) => time.hour == 12 && time.minute == 30);
                        }
                      });
                    },
                    child: TimeCard(
                      icon: Icons.sunny,
                      time: 'Afternoon',
                      isSelected: afternoon,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        night = !night;
                        if (night) {
                          _selectedTimes
                              .add(const TimeOfDay(hour: 20, minute: 0));
                        } else {
                          _selectedTimes.removeWhere(
                              (time) => time.hour == 20 && time.minute == 0);
                        }
                      });
                    },
                    child: TimeCard(
                      icon: Icons.mode_night,
                      time: 'Night',
                      isSelected: night,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'End Date: ${_formatDate(_endDate)}',
                    style: TextStyle(
                      color: kTextPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
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
              const SizedBox(height: 15),
              Text(
                'Additional notes',
                style: TextStyle(
                  color: kTextPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 15),
              Container(
                height: 100,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: kSecondary,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(255, 158, 158, 158),
                      blurRadius: 10,
                      offset: Offset(2, 3),
                    ),
                  ],
                ),
                child: TextField(
                  controller: notesController,
                  style: TextStyle(
                    color: kTextPrimary,
                  ),
                  maxLines: 2,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Additional notes...',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.grey[200],
                    backgroundColor: Colors.grey[300],
                    elevation: 3,
                  ),
                  onPressed: _addReminder,
                  child: Text(
                    'Add Reminder',
                    style: GoogleFonts.bebasNeue(
                      textStyle:
                          TextStyle(fontSize: 25, color: Colors.grey[800]),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              if (_reminderList.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Current Reminders',
                      style: TextStyle(
                        color: kTextPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (_reminderList.length > 5)
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AllRemindersPage(reminderList: _reminderList),
                            ),
                          );
                        },
                        child: const Text('View More'),
                      ),
                  ],
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: ListView.builder(
                    itemCount:
                        _reminderList.length > 5 ? 5 : _reminderList.length,
                    itemBuilder: (context, index) {
                      final reminder = _reminderList[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          title: Text(
                            reminder.name,
                            style: TextStyle(
                              color: kTextPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: _expandedIndex == index
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ...reminder.times.map((time) {
                                      return Text(
                                        'Time: ${time.format(context)}',
                                        style: TextStyle(
                                          color: kTextPrimary,
                                          fontSize: 14,
                                        ),
                                      );
                                    }).toList(),
                                    Text(
                                      'Start Date: ${_formatDate(reminder.startDate)}',
                                      style: TextStyle(
                                        color: kTextPrimary,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      'End Date: ${_formatDate(reminder.endDate)}',
                                      style: TextStyle(
                                        color: kTextPrimary,
                                        fontSize: 14,
                                      ),
                                    ),
                                    if (reminder.notes != null &&
                                        reminder.notes!.isNotEmpty)
                                      Text(
                                        'Notes: ${reminder.notes}',
                                        style: TextStyle(
                                          color: kTextPrimary,
                                          fontSize: 14,
                                        ),
                                      ),
                                  ],
                                )
                              : null,
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () =>
                                _deleteReminder(reminder.id, index),
                          ),
                          onTap: () {
                            setState(() {
                              _expandedIndex =
                                  _expandedIndex == index ? null : index;
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class TimeCard extends StatelessWidget {
  final IconData icon;
  final String time;
  final bool isSelected;

  const TimeCard({
    super.key,
    required this.icon,
    required this.time,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 105,
      width: 105,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: isSelected ? kTextPrimary : kSecondary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.white : kTextSecondary,
            size: 40,
          ),
          const SizedBox(height: 5),
          Text(
            time,
            style: TextStyle(
              color: isSelected ? Colors.white : kTextSecondary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
