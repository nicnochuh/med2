import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

import 'package:intl/intl.dart';

class Timepick extends StatefulWidget {
  const Timepick({super.key});

  @override
  State<Timepick> createState() => _TimepickState();
}

var textinput = TextEditingController();

class _TimepickState extends State<Timepick> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: TextField(
          decoration: const InputDecoration(
              hintText: 'hh : mm',
              contentPadding: EdgeInsets.all(15.0),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0))),
              filled: false),
          style: const TextStyle(fontSize: 24),
          controller: textinput,
          readOnly: true,
          onTap: () {
            DatePicker.showTimePicker(context, showTitleActions: true,
                onConfirm: (time) {
              setState(() {
                textinput.text = DateFormat("kk:mm").format(time);
              });
            }, currentTime: DateTime.now());
          },
        ),
      ),
    );
  }
}
