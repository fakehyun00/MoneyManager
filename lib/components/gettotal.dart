import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GetTotal extends StatefulWidget {
  const GetTotal({super.key});

  @override
  State<GetTotal> createState() => _GetTotalState();
}

class _GetTotalState extends State<GetTotal> {
  bool invisible = false;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .collection('details')
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
            double total = income.toDouble() - spending;
            return Row(
              children: [
                Text(
                  invisible
                      ? NumberFormat.simpleCurrency(
                              locale: 'vi-VN', decimalDigits: 0)
                          .format(total)
                      : '********',
                  style: const TextStyle(
                    fontSize: 25,
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      invisible = !invisible;
                    });
                  },
                  child: Icon(
                    invisible ? Icons.visibility : Icons.visibility_off,
                    size: 20,
                  ),
                )
              ],
            );
            // Text(total.toString());
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
