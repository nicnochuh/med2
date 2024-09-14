import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReminderModel {
  final String id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final List<TimeOfDay> times;
  final String? notes;

  ReminderModel({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.times,
    this.notes,
  });

  factory ReminderModel.fromMap(String id, Map<String, dynamic> data) {
    return ReminderModel(
      id: id,
      name: data['name'],
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      times: (data['times'] as List<dynamic>)
          .map((e) => TimeOfDay(hour: e['hour'], minute: e['minute']))
          .toList(),
      notes: data['notes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'startDate': startDate,
      'endDate': endDate,
      'times': times.map((e) => {'hour': e.hour, 'minute': e.minute}).toList(),
      'notes': notes,
    };
  }

  ReminderModel copyWith({
    String? id,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
    List<TimeOfDay>? times,
    String? notes,
  }) {
    return ReminderModel(
      id: id ?? this.id,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      times: times ?? this.times,
      notes: notes ?? this.notes,
    );
  }
}
