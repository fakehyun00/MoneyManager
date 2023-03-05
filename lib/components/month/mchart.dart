import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_chart/d_chart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MChart extends StatefulWidget {
  const MChart({super.key});

  @override
  State<MChart> createState() => _MChartState();
}

class _MChartState extends State<MChart> {
  DateTime month = DateTime(now.year, now.month, 1);
  DateTime nextmonth = DateTime(now.year, now.month + 1, 1);
  static DateTime now = DateTime.now();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('details')
            .where('date', isGreaterThanOrEqualTo: month, isLessThan: nextmonth)
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
