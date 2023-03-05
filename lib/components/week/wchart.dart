import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_chart/d_chart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WChart extends StatefulWidget {
  const WChart({super.key});

  @override
  State<WChart> createState() => _WChartState();
}

class _WChartState extends State<WChart> {
  late DateTime start;
  late DateTime end;
  DateTime now = DateTime.now();
  @override
  void initState() {
    super.initState();

    if (now.weekday == 1) {
      setState(() {
        start = DateTime(
          now.year,
          now.month,
          now.day,
        );
        end = DateTime.now().add(const Duration(days: 7));
      });
    }
    if (now.weekday == 2) {
      setState(() {
        start = DateTime.now().subtract(const Duration(days: 1));
        end = DateTime.now().add(const Duration(days: 5));
      });
    }
    if (now.weekday == 3) {
      setState(() {
        start = DateTime.now().subtract(const Duration(days: 2));
        end = DateTime.now().add(const Duration(days: 4));
      });
    }
    if (now.weekday == 4) {
      setState(() {
        start = DateTime.now().subtract(const Duration(days: 3));
        end = DateTime.now().add(const Duration(days: 3));
      });
    }
    if (now.weekday == 5) {
      setState(() {
        start = DateTime.now().subtract(const Duration(days: 4));
        end = DateTime.now().add(const Duration(days: 2));
      });
    }
    if (now.weekday == 6) {
      setState(() {
        start = DateTime.now().subtract(const Duration(days: 5));
        end = DateTime.now().add(const Duration(days: 1));
      });
    }
    if (now.weekday == 7) {
      setState(() {
        start = DateTime.now().subtract(const Duration(days: 6));
        end = DateTime(now.year, now.month, now.day, 23, 59, 59);
      });
    }
    // print(now.weekday);
    // print(start);
    // print(end);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .collection('details')
            .where('date',
                isGreaterThanOrEqualTo: start, isLessThanOrEqualTo: end)
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (_, snapshot) {
          if (snapshot.hasError) {
            return const Text('Error');
          }

          if (snapshot.hasData) {
            int income = 0;
            int spending = 0;
            for (var doc in snapshot.data!.docs) {
              if (doc['status'] == true) {
                spending += doc['cost'] as int;
              } else {
                income += doc['cost'] as int;
              }
            }
            if (income == 0 && spending == 0) {
              return const Center(child: Text('Hãy thêm thẻ chi tiêu'));
            } else {
              return SizedBox(
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: DChartBarCustom(
                    // max: 0,

                    showMeasureLine: true,
                    //showMeasureLabel: true,
                    radiusBar: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),

                    //spaceBetweenItem: 5,
                    showDomainLine: true,
                    showDomainLabel: true,
                    spaceMeasureLinetoChart: 70,
                    valuePadding: const EdgeInsets.all(10),
                    listData: [
                      DChartBarDataCustom(
                          value: spending.toDouble(),
                          label: 'Tổng Chi',
                          color: Colors.red),
                      DChartBarDataCustom(
                          value: income.toDouble(),
                          label: 'Tổng Thu',
                          color: Colors.green),
                      DChartBarDataCustom(value: 0, label: ''),
                    ],
                  ),
                ),
              );
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
