import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  var isDarkTheme = false.obs;

  @override
  void onInit() {
    super.onInit();
    isDarkTheme.value = Get.isDarkMode;
  }

  void toggleTheme() {
    isDarkTheme.value = !isDarkTheme.value;
    Get.changeThemeMode(isDarkTheme.value ? ThemeMode.dark : ThemeMode.light);
  }
}
