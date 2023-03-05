import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class WeekChart extends StatefulWidget {
  const WeekChart({super.key});

  @override
  State<WeekChart> createState() => _WeekChartState();
}

class _ChartData {
  _ChartData({this.x, this.y});
  final DateTime? x;
  final int? y;
}

class _WeekChartState extends State<WeekChart> {
  List<_ChartData> chartTData = <_ChartData>[];
  List<_ChartData> chartFData = <_ChartData>[];
  Future<void> getDataTrueFromFireStore() async {
    var snapShotsValue = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('details')
        .where('status', isEqualTo: true)
        .where('date', isGreaterThanOrEqualTo: start, isLessThan: end)
        .orderBy('date', descending: true)
        .get();

    List<_ChartData> list = snapShotsValue.docs
        // .where((element) => element['status'] == 'True')
        .map((e) =>
            _ChartData(x: e.data()['date'].toDate(), y: e.data()['cost']))
        .toList();

    setState(() {
      chartTData = list;
    });
  }

  Future<void> getDataFalseFromFireStore() async {
    var snapShotsValue = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('details')
        .where('status', isEqualTo: false)
        .where('date', isGreaterThanOrEqualTo: start, isLessThan: end)
        .orderBy('date', descending: true)
        .get();

    List<_ChartData> list = snapShotsValue.docs
        // .where((element) => element['status'] == 'True')
        .map((e) =>
            _ChartData(x: e.data()['date'].toDate(), y: e.data()['cost']))
        .toList();

    setState(() {
      chartFData = list;
    });
  }

  late DateTime start;
  late DateTime end;
  DateTime now = DateTime.now();
  // late int tstart = start.hashCode;

  @override
  void initState() {
    super.initState();

    if (now.weekday == 1) {
      setState(() {
        start = DateTime.now().subtract(const Duration(days: 7));
        end = DateTime.now();
      });
    }
    if (now.weekday == 2) {
      setState(() {
        start = DateTime.now().subtract(const Duration(days: 2));
        end = DateTime.now().add(const Duration(days: 5));
      });
    }
    if (now.weekday == 3) {
      setState(() {
        start = DateTime.now().subtract(const Duration(days: 3));
        end = DateTime.now().add(const Duration(days: 4));
      });
    }
    if (now.weekday == 4) {
      setState(() {
        start = DateTime.now().subtract(const Duration(days: 4));
        end = DateTime.now().add(const Duration(days: 3));
      });
    }
    if (now.weekday == 5) {
      setState(() {
        start = DateTime.now().subtract(const Duration(days: 5));
        end = DateTime.now().add(const Duration(days: 2));
      });
    }
    if (now.weekday == 6) {
      setState(() {
        start = DateTime.now().subtract(const Duration(days: 6));
        end = DateTime.now().add(const Duration(days: 1));
      });
    }
    if (now.weekday == 7) {
      setState(() {
        start = DateTime.now().subtract(const Duration(days: 7));
        end = DateTime.now();
      });
    }
    getDataTrueFromFireStore();
    getDataFalseFromFireStore();
    // print(now.weekday);
    // print(start);
    // print(end);
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        primaryXAxis: DateTimeAxis(),
        primaryYAxis: NumericAxis(),
        series: <ChartSeries<_ChartData, DateTime>>[
          LineSeries<_ChartData, DateTime>(
              color: Colors.green,
              dataSource: chartFData,
              xValueMapper: (_ChartData data, _) => data.x,
              yValueMapper: (_ChartData data, _) => data.y),
          LineSeries<_ChartData, DateTime>(
              color: Colors.red,
              dataSource: chartTData,
              xValueMapper: (_ChartData data, _) => data.x,
              yValueMapper: (_ChartData data, _) => data.y),
        ]);
  }
}
