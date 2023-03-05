import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:intl/intl.dart';

import '../../resource/style.dart';
import '../../services/database.dart';
import 'monthchart.dart';

class MonthDetail extends StatefulWidget {
  const MonthDetail({super.key});

  @override
  State<MonthDetail> createState() => _MonthDetailState();
}

class _MonthDetailState extends State<MonthDetail> {
  FirebaseFirestore ref = FirebaseFirestore.instance;
  var curUser = FirebaseAuth.instance.currentUser!.uid;

  DateTime month = DateTime(now.year, now.month, 1);
  DateTime nextmonth = DateTime(now.year, now.month + 1, 1);
  static DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background1,
      appBar: AppBar(
        flexibleSpace: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Text(
                'Thống kê tháng',
                style: Style.headLineStyle1,
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: ref
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('details')
              .where('date',
                  isGreaterThanOrEqualTo: month, isLessThan: nextmonth)
              .orderBy('date', descending: true)
              .snapshots(),
          builder: (_, snapshot) {
            if (snapshot.hasError) {
              return const Text('Error');
            }

            if (snapshot.hasData) {
              double monthtotal = 0;
              int income = 0;
              int spending = 0;
              for (var doc in snapshot.data!.docs) {
                if (doc['status'] == true) {
                  spending += doc['cost'] as int;
                } else {
                  income += doc['cost'] as int;
                }
              }
              monthtotal = income.toDouble() - spending.toDouble();
              final doc = snapshot.data!.docs;
              return Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      NumberFormat.simpleCurrency(
                              locale: 'vi-VN', decimalDigits: 0)
                          .format(monthtotal),
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    const MonthChart(),
                    const Divider(),
                    Expanded(
                      child: ListView.builder(
                        itemCount: doc.length,
                        itemBuilder: (_, i) {
                          final data = doc[i].data();
                          Timestamp t = data['date'] as Timestamp;
                          DateTime date = t.toDate();
                          return Slidable(
                              key: ObjectKey(doc),
                              endActionPane: ActionPane(
                                motion: const StretchMotion(),
                                children: [
                                  SlidableAction(
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomLeft: Radius.circular(10)),
                                      backgroundColor: Colors.green.shade100,
                                      icon: Icons.edit,
                                      onPressed: (context) {}),
                                  SlidableAction(
                                      borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(10)),
                                      backgroundColor: Colors.red.shade100,
                                      icon: Icons.delete,
                                      onPressed: (context) {
                                        DataBaseMethod.instance
                                            .onclickDelete(doc[i].id);
                                      })
                                ],
                              ),
                              child: ListTile(
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
                              ));
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}
