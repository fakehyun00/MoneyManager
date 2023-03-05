import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MonthChart extends StatefulWidget {
  const MonthChart({super.key});

  @override
  State<MonthChart> createState() => _MonthChartState();
}

class _MonthChartState extends State<MonthChart> {
  List<_ChartData> chartTData = <_ChartData>[];
  List<_ChartData> chartFData = <_ChartData>[];
  Future<void> getDataTrueFromFireStore() async {
    var snapShotsValue = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('details')
        .where('status', isEqualTo: true)
        .where('date', isGreaterThanOrEqualTo: month, isLessThan: nextmonth)
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
        .where('date', isGreaterThanOrEqualTo: month, isLessThan: nextmonth)
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

  DateTime month = DateTime(now.year, now.month, 1);
  DateTime nextmonth = DateTime(now.year, now.month + 1, 1);
  static DateTime now = DateTime.now();
  // late int tstart = start.hashCode;

  @override
  void initState() {
    super.initState();
    getDataTrueFromFireStore();
    getDataFalseFromFireStore();
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        title: ChartTitle(text: 'Chi tiêu trong tháng'),
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

var numberToWeekMap = {
  1: 'Chủ nhật',
  2: 'Thứ 2',
  3: 'Thứ 3',
  4: 'Thứ 4',
  5: 'Thứ 5',
  6: 'Thứ 6',
  7: 'Thứ 7',
};

class _ChartData {
  _ChartData({this.x, this.y});
  final DateTime? x;
  final int? y;
}
