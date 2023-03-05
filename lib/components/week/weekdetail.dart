import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:moneymanager/components/week/weekchart.dart';
import 'package:moneymanager/services/database.dart';

import '../../resource/style.dart';

class WeekDetail extends StatefulWidget {
  const WeekDetail({super.key});

  @override
  State<WeekDetail> createState() => _WeekDetailState();
}

class _WeekDetailState extends State<WeekDetail> {
  var curUser = FirebaseAuth.instance.currentUser!.uid;

  late DateTime start;
  late DateTime end;
  DateTime now = DateTime.now();
  // late int tstart = start.hashCode;

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
                'Thống kê tuần',
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
              .doc(cur)
              .collection('details')
              .where('date',
                  isGreaterThanOrEqualTo: start, isLessThanOrEqualTo: end)
              .orderBy('date', descending: false)
              .snapshots(),
          builder: (_, snapshot) {
            // int i = 0;
            if (snapshot.hasError) {
              return const Text('Error');
            }

            if (snapshot.hasData) {
              double weektotal = 0;
              int income = 0;
              int spending = 0;
              for (var doc in snapshot.data!.docs) {
                if (doc['status'] == true) {
                  spending += doc['cost'] as int;
                } else {
                  income += doc['cost'] as int;
                }
              }
              weektotal = income.toDouble() - spending.toDouble();
              final doc = snapshot.data!.docs;
              return Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      NumberFormat.simpleCurrency(
                              locale: 'vi-VN', decimalDigits: 0)
                          .format(weektotal),
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    const Text('Chi tiêu trong tuần'),
                    const WeekChart(),
                    const Divider(),
                    Expanded(
                      child: ListView.builder(
                        //scrollDirection: Axis.vertical,
                        //shrinkWrap: true,
                        itemCount: doc.length,
                        itemBuilder: (_, i) {
                          final data = doc[i].data();
                          Timestamp t = data['date'] as Timestamp;
                          DateTime date = t.toDate();

                          //var dt = DateTime.fromMillisecondsSinceEpoch(mili);
                          //var d24 = DateFormat('dd/MM/yyyy, HH-mm').format(dt);
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
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
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
                                ),
                              ),
                            ),
                          );
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
