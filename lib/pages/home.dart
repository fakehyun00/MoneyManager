// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moneymanager/components/gettotal.dart';
import 'package:moneymanager/components/month/month.dart';
import 'package:moneymanager/resource/style.dart';

import '../components/lastest.dart';
import '../components/week/week.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  bool invisible = false;
  String week = '';
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 2, vsync: this);
    return Scaffold(
      backgroundColor: background1,
      body: ListView(
        children: [
          Container(
              decoration: const BoxDecoration(
                  color: Color.fromARGB(108, 218, 218, 218)),
              padding: const EdgeInsets.all(30),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [GetTotal(), const Icon(Icons.notifications)],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Báo cáo chi tiêu',
                        style: GoogleFonts.alata(fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 27,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Color.fromARGB(108, 218, 218, 218)),
                          child: TabBar(
                              indicator: ShapeDecoration(
                                  color: Colors.amber,
                                  shape: UnderlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide.none)),
                              controller: tabController,
                              labelColor: Colors.amber,
                              indicatorColor: Colors.white,
                              unselectedLabelColor: Colors.white,
                              tabs: [
                                Text(
                                  'Tuần',
                                  style: GoogleFonts.alata(color: Colors.black),
                                ),
                                Text('Tháng',
                                    style:
                                        GoogleFonts.alata(color: Colors.black))
                              ]),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 500,
                          child: TabBarView(
                              controller: tabController,
                              children: [Week(), Month()]),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Lastest()
                ],
              )),
        ],
      ),
    );
  }
}
