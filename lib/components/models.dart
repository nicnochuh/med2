import 'package:flutter/material.dart';

class Model {
  final String id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final List<TimeOfDay> times;
  final String? notes;

  const Model({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.times,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'times': times.map((time) => '${time.hour}:${time.minute}').toList(),
      'notes': notes,
    };
  }

  static Model fromMap(String id, Map<String, dynamic> map) {
    return Model(
      id: id,
      name: map['name'],
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      times: (map['times'] as List)
          .map((time) => TimeOfDay(
                hour: int.parse(time.split(':')[0]),
                minute: int.parse(time.split(':')[1]),
              ))
          .toList(),
      notes: map['notes'],
    );
  }

  Model copyWith({
    String? id,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
    List<TimeOfDay>? times,
    String? notes,
  }) {
    return Model(
      id: id ?? this.id,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      times: times ?? this.times,
      notes: notes ?? this.notes,
    );
  }
}
