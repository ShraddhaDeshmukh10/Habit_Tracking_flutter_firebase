import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habit03/Login.dart';
import 'package:habit03/controller/ThemeController.dart';
import 'package:habit03/controller/UserContoller.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class Homescreen extends StatefulWidget {
  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final UserController userController = Get.put(UserController());
  final TextEditingController habitController = TextEditingController();
  final ThemeController themeController = Get.put(ThemeController());
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    userController.loadHabits();
    userController.loadProgress(); // Load progress for today
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Habit Tracker'),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: () {
              themeController.toggleTheme();
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Get.to(HabitTrackerLogin());
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            Row(
              children: [
                Obx(() {
                  return CircleAvatar(
                    radius: 30,
                    backgroundImage: userController.profileImageUrl.isEmpty
                        ? null
                        : NetworkImage(userController.profileImageUrl.value),
                    backgroundColor: Colors.grey[200],
                    child: userController.profileImageUrl.isEmpty
                        ? Icon(Icons.person, size: 30)
                        : null,
                  );
                }),
                IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: () async {
                    await userController.uploadProfileImage();
                    setState(() {}); // Refresh profile image
                  },
                ),
                SizedBox(width: 10),
                Obx(() {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userController.email.value,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  );
                }),
              ],
            ),
            SizedBox(height: 20),

            // Add Habit Section
            TextField(
              controller: habitController,
              decoration: InputDecoration(
                labelText: "Add New Habit",
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    userController.addHabit(habitController.text);
                    habitController.clear();
                    userController
                        .saveProgress(); // Save progress after adding habit
                  },
                ),
              ),
            ),
            SizedBox(height: 20),

            // Habits List
            Obx(() {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: userController.habits.length,
                itemBuilder: (context, index) {
                  final habit = userController.habits[index];
                  return ListTile(
                    title: Text(habit.name),
                    subtitle: Text('Time Spent: ${habit.timeSpent} mins'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            userController.decrementTime(index);
                            userController
                                .saveProgress(); // Save progress after updating time
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            userController.incrementTime(index);
                            userController
                                .saveProgress(); // Save progress after updating time
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            userController.deleteHabit(index);
                            userController
                                .saveProgress(); // Save progress after deleting habit
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            }),

            SizedBox(height: 20),

            // Habit Tracking Pie Chart
            Text(
              'Habit Progress',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 200,
              child: Obx(() {
                final completedHabits = userController.habits
                    .where((habit) => habit.timeSpent > 0)
                    .toList();
                final spots = completedHabits
                    .asMap()
                    .entries
                    .map((e) => PieChartSectionData(
                          value: e.value.timeSpent.toDouble(),
                          color:
                              Colors.primaries[e.key % Colors.primaries.length],
                          title: e.value.name,
                        ))
                    .toList();

                return PieChart(
                  PieChartData(
                    sections: spots,
                    borderData: FlBorderData(show: false),
                    centerSpaceRadius: 40,
                  ),
                );
              }),
            ),

            SizedBox(height: 20),

            // Progress Overview Dashboard
            Text(
              'Progress Overview',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Obx(() {
              final completedHabits = userController.habits
                  .where((habit) => habit.timeSpent > 0)
                  .toList();
              final streaks = completedHabits.length;
              final totalTimeSpent = completedHabits.fold(
                  0, (sum, habit) => sum + habit.timeSpent);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Time Spent: $totalTimeSpent mins'),
                  Text('Habit Streaks: $streaks'),
                ],
              );
            }),

            SizedBox(height: 20),

            // Calendar with Habit Streaks
            Text(
              'Habit Streaks',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Obx(() {
              final streakDates = userController.habits
                  .expand((habit) => habit.completionDates)
                  .map((date) => DateTime(date.year, date.month, date.day))
                  .toSet()
                  .toList();

              return TableCalendar(
                focusedDay: DateTime.now(),
                firstDay: DateTime.utc(2020, 01, 01),
                lastDay: DateTime.utc(2100, 01, 01),
                calendarFormat: CalendarFormat.month,
                selectedDayPredicate: (day) => streakDates.contains(day),
                eventLoader: (day) {
                  return streakDates.contains(day) ? ['Habit Completed'] : [];
                },
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  markerDecoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    selectedDate = selectedDay;
                  });
                },
              );
            }),

            // Display selected date details
            if (selectedDate != null) ...[
              SizedBox(height: 20),
              Text(
                'Details for ${DateFormat('yyyy-MM-dd').format(selectedDate!)}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Obx(() {
                final completedHabits = userController.habits
                    .where((habit) => habit.completionDates.any((date) =>
                        date.year == selectedDate!.year &&
                        date.month == selectedDate!.month &&
                        date.day == selectedDate!.day))
                    .toList();
                final totalTimeSpent = completedHabits.fold(
                    0, (sum, habit) => sum + habit.timeSpent);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...completedHabits.map((habit) => Text(habit.name)),
                    SizedBox(height: 10),
                    Text('Total Time Spent: $totalTimeSpent mins'),
                  ],
                );
              }),
            ],
          ],
        ),
      ),
    );
  }
}
