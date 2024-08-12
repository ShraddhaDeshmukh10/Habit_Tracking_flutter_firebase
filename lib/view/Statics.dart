import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:habit03/controller/UserContoller.dart';

class StatisticsChart extends StatelessWidget {
  final UserController userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final spots = userController.habits
          .asMap()
          .entries
          .map((e) => FlSpot(e.key.toDouble(), e.value.timeSpent.toDouble()))
          .toList();

      return Scaffold(
        appBar: AppBar(title: Text('Statistics')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(show: true),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: Colors.blue,
                  barWidth: 4,
                  belowBarData: BarAreaData(show: false),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
