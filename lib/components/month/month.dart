import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:moneymanager/resource/columnbuilder.dart';

import '../../resource/style.dart';
import 'mchart.dart';
import 'monthdetail.dart';

class Month extends StatefulWidget {
  const Month({super.key});

  @override
  State<Month> createState() => _MonthState();
}

class _MonthState extends State<Month> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('details')
            .where('date', isGreaterThanOrEqualTo: month, isLessThan: nextmonth)
            .orderBy('date', descending: false)
            .limit(3)
            .snapshots(),
        builder: (_, snapshot) {
          if (snapshot.hasError) {
            return const Text('Error');
          }
          if (snapshot.hasData) {
            final doc = snapshot.data!.docs;
            return Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                const MChart(),
                const SizedBox(
                  height: 50,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Chi tiêu nhiều nhất',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MonthDetail()));
                  },
                  child: Card(
                    elevation: 0,
                    child: ColumnBuilder(
                        itemCount: (doc.length > 3 ? 3 : doc.length),
                        itemBuilder: (_, i) {
                          final data = doc[i].data();
                          Timestamp t = data['date'] as Timestamp;
                          DateTime date = t.toDate();
                          return ListTile(
                            leading: Image.network(data['url']),
                            title: Text(
                              data['contentname'],
                              style: const TextStyle(fontSize: 15),
                            ),
                            subtitle: Text(
                                '${date.day} ${numberToMonthMap[date.month]} ${date.year}'),
                            trailing: Text(
                              NumberFormat.simpleCurrency(
                                      locale: 'vi-VN', decimalDigits: 0)
                                  .format(data['cost']),
                              style: TextStyle(
                                  fontSize: 15,
                                  color: data['status'] == true
                                      ? Colors.red
                                      : Colors.green),
                            ),
                          );
                        }),
                  ),
                ),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}
