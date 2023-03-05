import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Style {
  static TextStyle headLineStyle1 = GoogleFonts.alata(
      fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black);
  static TextStyle headLineStyle2 =
      GoogleFonts.alata(fontSize: 18, fontWeight: FontWeight.w500);
}

var cur = FirebaseAuth.instance.currentUser!.uid;
FirebaseFirestore ref = FirebaseFirestore.instance;
var numberToWeekMap = {
  1: 'Thứ 2',
  2: 'Thứ 3',
  3: 'Thứ 4',
  4: 'Thứ 5',
  5: 'Thứ 6',
  6: 'Thứ 7',
  7: 'Chủ nhật',
};
var numberToMonthMap = {
  1: '01',
  2: '02',
  3: '03',
  4: '04',
  5: '05',
  6: '06',
  7: '07',
  8: '08',
  9: '09',
  10: '10',
  11: '11',
  12: '12',
};
DateTime month = DateTime(now.year, now.month, 1);
DateTime nextmonth = DateTime(now.year, now.month + 1, 1);
DateTime now = DateTime.now();

Color background1 = const Color(0xFFD6E2EA);

final ButtonStyle degree = ElevatedButton.styleFrom(
    //minimumSize: const Size(60, 30),
    backgroundColor: const Color.fromARGB(255, 166, 188, 202),
    elevation: 0,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20))));
final ButtonStyle agree = ElevatedButton.styleFrom(
    //minimumSize: const Size(60, 30),
    backgroundColor: Colors.white.withOpacity(0.3),
    elevation: 0,
    foregroundColor: Colors.black,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20))));
