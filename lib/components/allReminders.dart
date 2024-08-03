import 'package:flutter/material.dart';
import 'package:medtrack/components/models.dart';
import 'package:medtrack/pages/constants.dart';

class AllRemindersPage extends StatelessWidget {
  final List<Model> reminderList;

  const AllRemindersPage({super.key, required this.reminderList});

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimary,
      appBar: AppBar(
        title: Text('All Reminders', style: TextStyle(color: kTextPrimary)),
        backgroundColor: Colors.grey[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: reminderList.length,
          itemBuilder: (context, index) {
            final reminder = reminderList[index];
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
                subtitle: Column(
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
                    if (reminder.notes != null && reminder.notes!.isNotEmpty)
                      Text(
                        'Notes: ${reminder.notes}',
                        style: TextStyle(
                          color: kTextPrimary,
                          fontSize: 14,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
