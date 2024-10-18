import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

class Habit {
  final String name;
  int timeSpent;
  final List<DateTime> completionDates;

  Habit({
    required this.name,
    required this.timeSpent,
    required this.completionDates,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'timeSpent': timeSpent,
      'completionDates':
          completionDates.map((date) => date.toIso8601String()).toList(),
    };
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      name: map['name'],
      timeSpent: map['timeSpent'],
      completionDates: (map['completionDates'] as List<dynamic>?)
              ?.map((date) => DateTime.parse(date as String))
              .toList() ??
          [],
    );
  }
}

class UserController extends GetxController {
  var email = ''.obs;
  var profileImageUrl = ''.obs;
  var habits = <Habit>[].obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    email.value = _auth.currentUser?.email ?? '';
    await loadProfileImage();
    loadHabits();
  }

  Future<void> uploadProfileImage() async {
    if (kIsWeb) {
      print('Image upload not supported on the web platform.');
      return;
    }

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final uid = _auth.currentUser?.uid;

      if (uid != null) {
        try {
          final storageRef = FirebaseStorage.instance
              .ref()
              .child('profile_images')
              .child('$uid.jpg');

          final uploadTask = storageRef.putFile(file);

          uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
            print(
                'Upload progress: ${snapshot.bytesTransferred}/${snapshot.totalBytes}');
          });

          final downloadUrl = await (await uploadTask).ref.getDownloadURL();
          profileImageUrl.value = downloadUrl;
          await _firestore.collection('users').doc(uid).update({
            'profileImageUrl': downloadUrl,
          });

          print('Image uploaded successfully: $downloadUrl');
        } catch (e) {
          print('Error uploading image: $e');
        }
      }
    }
  }

  Future<void> loadProfileImage() async {
    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      try {
        final doc = await _firestore.collection('users').doc(uid).get();
        profileImageUrl.value = doc.data()?['profileImageUrl'] ?? '';
        print('Loaded profile image URL: ${profileImageUrl.value}');
      } catch (e) {
        print('Error loading image: $e');
      }
    }
  }

  Future<void> saveLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email.value);
  }

  Future<void> loadLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    email.value = prefs.getString('email') ?? '';
  }

  void saveProgress() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final userName = userDoc.data()?['name'] ?? 'Unknown';

      final progressData = {
        'date': DateTime.now().toIso8601String(),
        'userName': userName,
        'habits': habits
            .where((h) => h.name.isNotEmpty)
            .map((h) => {
                  'name': h.name,
                  'timeSpent': h.timeSpent,
                  'completionDates': h.completionDates
                      .map((d) => d.toIso8601String())
                      .toList(),
                })
            .toList(),
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('progress')
          .add(progressData);
    }
  }

  Future<void> loadProgress() async {
    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = startOfDay.add(Duration(days: 1));

      print('Loading progress from $startOfDay to $endOfDay'); // Debugging

      final querySnapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('progress')
          .where('date', isGreaterThanOrEqualTo: startOfDay.toIso8601String())
          .where('date', isLessThan: endOfDay.toIso8601String())
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first.data();
        print('Loaded progress: $doc'); // Debugging

        habits.value = (doc['habits'] as List<dynamic>).map((h) {
          final completionDates = (h['completionDates'] as List<dynamic>)
              .map((d) => DateTime.parse(d))
              .toList();
          return Habit(
            name: h['name'],
            timeSpent: h['timeSpent'],
            completionDates: completionDates,
          );
        }).toList();
      } else {
        print('No progress found for today.');
      }
    }
  }

  void markHabitAsCompleted(int index) async {
    final habit = habits[index];
    habit.completionDates.add(DateTime.now());
    habits[index] = habit;
    habits.refresh();
    saveHabits();
  }

  void addCompletionDate(int index, DateTime date) async {
    final habit = habits[index];
    habit.completionDates.add(date);
    habits[index] = habit;
    habits.refresh();
    saveHabits();
  }

  void addHabit(String habitName) async {
    if (habitName.isNotEmpty) {
      final habit = Habit(name: habitName, timeSpent: 0, completionDates: []);
      habits.add(habit);
      saveHabits();
    } else {
      print('Habit name cannot be empty');
    }
  }

  void deleteHabit(int index) async {
    habits.removeAt(index);
    saveHabits();
  }

  void incrementTime(int index) async {
    habits[index].timeSpent += 10;
    habits.refresh();
    saveHabits();
  }

  void decrementTime(int index) async {
    habits[index].timeSpent =
        (habits[index].timeSpent - 10).clamp(0, double.infinity).toInt();
    habits.refresh();
    saveHabits();
  }

  void saveHabits() async {
    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      final userDoc = await _firestore.collection('users').doc(uid).get();
      final userName = userDoc.data()?['name'] ?? 'Unknown';

      await _firestore
          .collection('user_data')
          .doc(userName) // Saving habits under the user's name
          .set({
        'habits': habits.map((h) => h.toMap()).toList(),
      });
    }
  }

  void loadHabits() async {
    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      final userDoc = await _firestore.collection('users').doc(uid).get();
      final userName = userDoc.data()?['name'] ?? 'Unknown';

      final doc = await _firestore.collection('user_data').doc(userName).get();

      if (doc.exists) {
        final List<dynamic> loadedHabits = doc.data()?['habits'] ?? [];
        habits.value = loadedHabits.map((h) => Habit.fromMap(h)).toList();
      }
    }
  }
}
