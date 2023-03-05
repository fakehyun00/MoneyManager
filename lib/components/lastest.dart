import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:moneymanager/pages/allitem.dart';
import 'package:moneymanager/resource/columnbuilder.dart';

import '../resource/style.dart';

class Lastest extends StatefulWidget {
  const Lastest({super.key});

  @override
  State<Lastest> createState() => _LastestState();
}

class _LastestState extends State<Lastest> {
  bool status = true;
  var itemname = 'cost';
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .collection('details')
            .orderBy(itemname, descending: status)
            .limit(5)
            .snapshots(),
        builder: (_, snapshot) {
          if (snapshot.hasError) {
            return const Text('Error');
          }
          if (snapshot.hasData) {
            final doc = snapshot.data!.docs;
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tất cả giao dịch',
                      style: GoogleFonts.alata(fontSize: 18),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          status = !status;
                        });
                      },
                      child: Text(
                        status ? 'Giá giảm dần ↓' : 'Giá tăng dần ↑',
                        style: GoogleFonts.alata(
                            color: Colors.green, fontSize: 18),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: ColumnBuilder(
                      itemCount: doc.length,
                      itemBuilder: (_, i) {
                        final data = doc[i].data();
                        Timestamp t = data['date'] as Timestamp;
                        DateTime date = t.toDate();

                        //var dt = DateTime.fromMillisecondsSinceEpoch(mili);
                        //var d24 = DateFormat('dd/MM/yyyy, HH-mm').format(dt);
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const AllItem()));
                          },
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
                                  fontSize: 18,
                                  color: data['status'] == true
                                      ? Colors.red
                                      : Colors.green),
                            ),
                          ),
                        );
                      }),
                ),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}
