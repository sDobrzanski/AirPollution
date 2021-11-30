import 'dart:math';

import 'package:air_pollution_app/models/air_data.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CustomBarChart extends StatefulWidget {
  final int index;
  final List<ListElement>? list;

  const CustomBarChart({
    required this.index,
    this.list,
    Key? key,
  }) : super(key: key);

  @override
  _CustomBarChartState createState() => _CustomBarChartState();
}

class _CustomBarChartState extends State<CustomBarChart> {
  late List<Component> components;
  List<int?> dates = [];
  List<double> values = [];
  List<BarChartGroupData> barChartGroupData = [];
  String name = '';
  int touchedGroupIndex = -1;
  final Color barColor = const Color(0xff53fdd7);
  final double width = 7;

  @override
  void initState() {
    super.initState();

    if (widget.list != null) {
      name = widget.list!.first.components!.keys.elementAt(widget.index);
      final int interatorValue = widget.list!.length ~/ 7;
      for (int i= 0; i < widget.list!.length; i = i + interatorValue) {
        if (widget.list![i].components != null &&
            widget.list![i].components![name] != null &&
            widget.list![i].dt != null) {
          values.add(widget.list![i].components![name]!);
          dates.add(widget.list![i].dt);
        }
      }

      for (int i = 0; i < values.length; i++) {
        barChartGroupData.add(BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              y: values[i],
              colors: [barColor],
              width: width,
            ),
          ],
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      color: Color(0xff2c4260),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              getName(name),
              style: const TextStyle(color: Colors.white, fontSize: 22),
            ),
            const SizedBox(height: 5),
            if (barChartGroupData.isNotEmpty)
              Expanded(
                child: BarChart(
                  BarChartData(
                    maxY: values.isNotEmpty ? values.reduce(max) : 20,
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: SideTitles(showTitles: false),
                      topTitles: SideTitles(showTitles: false),
                      bottomTitles: SideTitles(
                        showTitles: true,
                        getTextStyles: (context, value) => const TextStyle(
                            color: Color(0xff7589a2),
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                        margin: 20,
                        getTitles: (double value) {
                          if (dates.isNotEmpty) {
                            DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(dates[value.toInt()]! * 1000, isUtc: true);
                            String convertedDateTime = "${dateTime.year.toString()}-${dateTime.month.toString().padLeft(2,'0')}-${dateTime.day.toString().padLeft(2,'0')}";
                            return convertedDateTime;
                          } else {
                            return '0';
                          }
                        },
                      ),
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    barGroups: barChartGroupData,
                    gridData: FlGridData(show: true),
                  ),
                  swapAnimationDuration: Duration(milliseconds: 150),
                  // Optional
                  swapAnimationCurve: Curves.linear, // Optional
                ),
              ),
          ],
        ),
      ),
    );
  }

  String getName(String shortName){
    switch (shortName) {
      case 'co':
        return 'Carbon monoxide';
      case 'no':
        return 'Nitrogen oxide';
      case 'no2':
        return 'Nitrogen dioxide';
      case 'o3':
        return 'Ozone ';
      case 'so2':
        return 'Sulphur dioxide';
      case 'pm2_5':
        return 'Particulate matter 2.5';
      case 'pm10':
        return 'Particulate matter 10';
      case 'nh3':
        return 'Ammonia ';
      default:
          return '';
    }
  }

}
