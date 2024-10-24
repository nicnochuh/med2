import 'package:flutter/material.dart';
import 'package:medtrack/components/models.dart';

class AllRemindersScreen extends StatelessWidget {
  final List<Model> reminders;

  const AllRemindersScreen({super.key, required this.reminders});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Reminders'),
        backgroundColor: Colors.grey[300],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: reminders.isNotEmpty
              ? ListView.builder(
                  itemCount: reminders.length,
                  itemBuilder: (context, index) {
                    final reminder = reminders[index];
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        title: Text(reminder.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 5),
                            Text(
                              'Times: ${reminder.times.map((time) => time.format(context)).join(', ')}',
                            ),
                            const SizedBox(height: 5),
                            Text('End Date: ${_formatDate(reminder.endDate)}'),
                            if (reminder.notes!.isNotEmpty)
                              Text('Notes: ${reminder.notes}'),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : Center(
                  child: Text(
                    'No Reminders Available',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 18,
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
