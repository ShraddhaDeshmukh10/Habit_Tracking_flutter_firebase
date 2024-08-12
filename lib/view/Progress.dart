import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit03/controller/UserContoller.dart';

class ProgressDashboard extends StatelessWidget {
  final UserController userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final completedHabits =
          userController.habits.where((habit) => habit.timeSpent > 0).toList();
      final streaks = completedHabits.length; // Simple streaks calculation
      final totalTimeSpent =
          completedHabits.fold(0, (sum, habit) => sum + habit.timeSpent);

      return Scaffold(
        appBar: AppBar(title: Text('Progress Dashboard')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total Time Spent: $totalTimeSpent mins'),
              SizedBox(height: 10),
              Text('Habit Streaks: $streaks'),
              // Add more widgets here for further breakdowns
            ],
          ),
        ),
      );
    });
  }
}
