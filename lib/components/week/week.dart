// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:moneymanager/components/week/wchart.dart';
import 'package:moneymanager/components/week/weekdetail.dart';
import 'package:moneymanager/resource/columnbuilder.dart';

import '../../resource/style.dart';

class Week extends StatefulWidget {
  const Week({super.key});

  @override
  State<Week> createState() => _WeekState();
}

class _WeekState extends State<Week> {
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

    print(now.weekday);
    print(start);
    print(end);
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
                const WChart(),
                const SizedBox(
                  height: 50,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Chi tiêu nhiều nhất',
                    style: GoogleFonts.alata(
                      fontSize: 18,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const WeekDetail()));
                  },
                  child: Card(
                    elevation: 0,
                    // shape: const RoundedRectangleBorder(
                    //   side: BorderSide.none,
                    //   //   //   color: Theme.of(context).colorScheme.outline,
                    //   //   //),
                    //   //   borderRadius: BorderRadius.all(Radius.circular(12)),
                    // ),
                    // color: Colors.white,
                    child: ColumnBuilder(
                        itemCount: doc.length,
                        //(doc.length > 3 ? 3 : doc.length),
                        itemBuilder: (_, i) {
                          final data = doc[i].data();
                          Timestamp t = data['date'] as Timestamp;
                          DateTime date = t.toDate();

                          //var dt = DateTime.fromMillisecondsSinceEpoch(mili);
                          //var d24 = DateFormat('dd/MM/yyyy, HH-mm').format(dt);
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
