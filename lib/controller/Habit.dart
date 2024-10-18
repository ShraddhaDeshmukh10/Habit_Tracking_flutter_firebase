import 'package:flutter/material.dart';

class Habit {
  final String name;
  late int timeSpent;
  final List<DateTime> completionDates;

  Habit({
    required this.name,
    required this.timeSpent,
    required this.completionDates,
  });

  Map<String, dynamic> toMap() => {
        'name': name,
        'timeSpent': timeSpent,
        'completionDates':
            //completionDates.map((e) => e.toIso8601String()).toList(),
            completionDates.map((date) => date.toIso8601String()).toList(),
      };

  factory Habit.fromMap(Map<String, dynamic> map) => Habit(
        name: map['name'],
        timeSpent: map['timeSpent'],
        completionDates: (map['completionDates'] as List<dynamic>?)
                ?.map((e) => DateTime.parse(e as String))
                .toList() ??
            [],
      );
}
