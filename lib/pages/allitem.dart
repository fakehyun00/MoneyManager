import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_chart/d_chart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../resource/style.dart';

class AllItem extends StatefulWidget {
  const AllItem({super.key});

  @override
  State<AllItem> createState() => _AllItemState();
}

class _AllItemState extends State<AllItem> {
  FirebaseFirestore ref = FirebaseFirestore.instance;
  var curUser = FirebaseAuth.instance.currentUser!.uid;
  String? value;
  String? url;
  bool? status;

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
                'Tất cả khoản thu chi',
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
      body: StreamBuilder<QuerySnapshot>(
          stream: ref
              .collection('users')
              .doc(cur)
              .collection('details')
              .snapshots(),
          builder: (_, snapshot) {
            if (snapshot.hasError) {
              return const Text('Error');
            }
            if (snapshot.hasData) {
              double foodto = 0;
              double moveto = 0;
              double hometo = 0;
              double beautyto = 0;
              double sportto = 0;
              double otherto = 0;
              double salaryto = 0;
              for (var doc in snapshot.data!.docs) {
                if (doc['contentname'] == 'Ăn uống') {
                  int food = doc['cost'];
                  foodto += food;
                }
                if (doc['contentname'] == 'Làm đẹp') {
                  int beauty = doc['cost'];
                  beautyto += beauty;
                }
                if (doc['contentname'] == 'Thuê nhà') {
                  int home = doc['cost'];
                  hometo += home;
                }
                if (doc['contentname'] == 'Thể dục thể thao') {
                  int sport = doc['cost'];
                  sportto += sport;
                }
                if (doc['contentname'] == 'Di chuyển') {
                  int move = doc['cost'];
                  moveto += move;
                }
                if (doc['contentname'] == 'Nguồn thu khác') {
                  int other = doc['cost'];
                  otherto += other;
                }
                if (doc['contentname'] == 'Lương') {
                  int salary = doc['cost'];
                  salaryto += salary;
                }
              }

              double income = 0;
              income = otherto + salaryto;
              double spendingtotal = 0;

              spendingtotal = foodto + moveto + hometo + sportto + beautyto;
              double incometotal = salaryto + otherto;
              double foodpercent = (foodto / spendingtotal) * 100;
              double movepercent = (moveto / spendingtotal) * 100;
              double homepercent = (hometo / spendingtotal) * 100;
              double beautypercent = (beautyto / spendingtotal) * 100;
              double sportpercent = (sportto / spendingtotal) * 100;
              double otherpercent = (otherto / incometotal) * 100;
              double salarypercent = (salaryto / incometotal) * 100;
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      (spendingtotal != 0)
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              height: MediaQuery.of(context).size.width / 2,
                              child: DChartPie(
                                data: [
                                  {'domain': 'Ăn uống', 'measure': foodpercent},
                                  {
                                    'domain': 'Di chuyển',
                                    'measure': movepercent
                                  },
                                  {
                                    'domain': 'Thuê nhà',
                                    'measure': homepercent
                                  },
                                  {
                                    'domain': 'Làm đẹp',
                                    'measure': beautypercent
                                  },
                                  {
                                    'domain': 'Thể dục thể thao',
                                    'measure': sportpercent
                                  }
                                ],
                                fillColor: (pieData, index) {
                                  switch (pieData['domain']) {
                                    case 'Ăn uống':
                                      return const Color.fromARGB(
                                        255,
                                        153,
                                        204,
                                        255,
                                      );
                                    case 'Di chuyển':
                                      return const Color.fromARGB(
                                          255, 102, 255, 255);
                                    case 'Thuê nhà':
                                      return const Color.fromARGB(
                                          255, 255, 255, 153);
                                    case 'Làm đẹp':
                                      return const Color.fromARGB(
                                          255, 255, 153, 153);
                                    case 'Thể dục thể thao':
                                      return const Color.fromARGB(
                                          255, 255, 153, 255);
                                  }
                                },
                              ),
                            )
                          : SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              height: MediaQuery.of(context).size.width / 2,
                            ),
                      (incometotal != 0)
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              height: MediaQuery.of(context).size.width / 2,
                              child: DChartPie(
                                //donutWidth: 0,\
                                showLabelLine: false,
                                pieLabel: (pieData, index) {
                                  switch (pieData['domain']) {
                                    case 'Nguồn thu khác':
                                      return '${otherpercent.toStringAsFixed(1)}%';
                                    case 'Lương':
                                      return '${salarypercent.toStringAsFixed(1)}%';

                                    default:
                                  }
                                },
                                data: [
                                  {
                                    'domain': 'Nguồn thu khác',
                                    'measure': otherpercent
                                  },
                                  {'domain': 'Lương', 'measure': salarypercent},
                                ],
                                fillColor: (pieData, index) {
                                  switch (pieData['domain']) {
                                    case 'Lương':
                                      return const Color.fromARGB(
                                          255, 238, 238, 228);
                                    case 'Nguồn thu khác':
                                      return const Color.fromARGB(
                                          255, 139, 233, 140);
                                  }
                                },
                              ),
                            )
                          : SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              height: MediaQuery.of(context).size.width / 2,
                            ),
                    ],
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //   children: [
                  //     // SizedBox(
                  //     //   width: MediaQuery.of(context).size.width / 3,
                  //     //   height: MediaQuery.of(context).size.width / 2.5,
                  //     //   child: DChartPie(
                  //     //     data: [
                  //     //       {'domain': 'Ăn uống', 'measure': foodpercent},
                  //     //       {'domain': 'Di chuyển', 'measure': movepercent},
                  //     //       {'domain': 'Thuê nhà', 'measure': homepercent},
                  //     //       {'domain': 'Làm đẹp', 'measure': beautypercent},
                  //     //       {'domain': 'Thể dục thể thao', 'measure': sportpercent}
                  //     //     ],
                  //     //     fillColor: (pieData, index) {
                  //     //       switch (pieData['domain']) {
                  //     //         case 'Ăn uống':
                  //     //           return const Color.fromARGB(
                  //     //             255,
                  //     //             153,
                  //     //             204,
                  //     //             255,
                  //     //           );
                  //     //         case 'Di chuyển':
                  //     //           return const Color.fromARGB(255, 102, 255, 255);
                  //     //         case 'Thuê nhà':
                  //     //           return const Color.fromARGB(255, 255, 255, 153);
                  //     //         case 'Làm đẹp':
                  //     //           return const Color.fromARGB(255, 255, 153, 153);
                  //     //         case 'Thể dục thể thao':
                  //     //           return const Color.fromARGB(255, 255, 153, 255);
                  //     //       }
                  //     //     },
                  //     //   ),
                  //     // ),
                  //     SizedBox(
                  //       width: MediaQuery.of(context).size.width / 2,
                  //       height: MediaQuery.of(context).size.width / 2,
                  //       child: DChartPie(
                  //         //donutWidth: 0,\
                  //         showLabelLine: false,
                  //         pieLabel: (pieData, index) {
                  //           switch (pieData['domain']) {
                  //             case 'Ăn uống':
                  //               return '${foodpercent.toStringAsFixed(1)}%';
                  //             case 'Di chuyển':
                  //               return '${movepercent.toStringAsFixed(1)}%';
                  //             case 'Thuê nhà':
                  //               return '${homepercent.toStringAsFixed(1)}%';
                  //             case 'Làm đẹp':
                  //               return '${beautypercent.toStringAsFixed(1)}%';
                  //             case 'Thể dục thể thao':
                  //               return '${sportpercent.toStringAsFixed(1)}%';
                  //             default:
                  //           }
                  //         },
                  //         data: [
                  //           {'domain': 'Ăn uống', 'measure': foodpercent},
                  //           {'domain': 'Di chuyển', 'measure': movepercent},
                  //           {'domain': 'Thuê nhà', 'measure': homepercent},
                  //           {'domain': 'Làm đẹp', 'measure': beautypercent},
                  //           {
                  //             'domain': 'Thể dục thể thao',
                  //             'measure': sportpercent
                  //           }
                  //         ],
                  //         fillColor: (pieData, index) {
                  //           switch (pieData['domain']) {
                  //             case 'Ăn uống':
                  //               return const Color.fromARGB(255, 234, 182, 118);
                  //             case 'Di chuyển':
                  //               return const Color.fromARGB(255, 226, 135, 67);
                  //             case 'Thuê nhà':
                  //               return const Color.fromARGB(255, 118, 181, 197);
                  //             case 'Làm đẹp':
                  //               return const Color.fromARGB(255, 30, 129, 176);
                  //             case 'Thể dục thể thao':
                  //               return const Color.fromARGB(255, 21, 76, 121);
                  //           }
                  //         },
                  //       ),
                  //     ),
                  //     SizedBox(
                  //       width: MediaQuery.of(context).size.width / 2,
                  //       height: MediaQuery.of(context).size.width / 2,
                  //       child: DChartPie(
                  //         //donutWidth: 0,\
                  //         showLabelLine: false,
                  //         pieLabel: (pieData, index) {
                  //           switch (pieData['domain']) {
                  //             case 'Nguồn thu khác':
                  //               return '${otherpercent.toStringAsFixed(1)}%';
                  //             case 'Lương':
                  //               return '${salarypercent.toStringAsFixed(1)}%';

                  //             default:
                  //           }
                  //         },
                  //         data: [
                  //           {
                  //             'domain': 'Nguồn thu khác',
                  //             'measure': otherpercent
                  //           },
                  //           {'domain': 'Lương', 'measure': salarypercent},
                  //         ],
                  //         fillColor: (pieData, index) {
                  //           switch (pieData['domain']) {
                  //             case 'Lương':
                  //               return const Color.fromARGB(255, 238, 238, 228);
                  //             case 'Nguồn thu khác':
                  //               return const Color.fromARGB(255, 139, 233, 140);
                  //           }
                  //         },
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: Image.network(
                              'https://cdn-icons-png.flaticon.com/512/4359/4359642.png'),
                          title: Text(
                            'Ăn uống',
                            style: GoogleFonts.alata(fontSize: 20),
                          ),
                          subtitle: SizedBox(
                              height: 15,
                              width: 15,
                              child: Container(
                                  color: const Color.fromARGB(
                                      255, 234, 182, 118))),
                          trailing: Text(
                            NumberFormat.simpleCurrency(
                                    locale: 'vi-VN', decimalDigits: 0)
                                .format(foodto),
                            style: GoogleFonts.alata(fontSize: 20),
                          ),
                        ),
                        ListTile(
                          leading: Image.network(
                              'https://cdn-icons-png.flaticon.com/512/7496/7496829.png'),
                          title: Text(
                            'Di chuyển',
                            style: GoogleFonts.alata(fontSize: 20),
                          ),
                          subtitle: SizedBox(
                            height: 15,
                            width: 15,
                            child: Container(
                                color: const Color.fromARGB(255, 226, 135, 67)),
                          ),
                          trailing: Text(
                            NumberFormat.simpleCurrency(
                                    locale: 'vi-VN', decimalDigits: 0)
                                .format(moveto),
                            style: GoogleFonts.alata(fontSize: 20),
                          ),
                        ),
                        ListTile(
                          leading: Image.network(
                              'https://cdn-icons-png.flaticon.com/512/7399/7399138.png'),
                          title: Text(
                            'Thuê nhà',
                            style: GoogleFonts.alata(fontSize: 20),
                          ),
                          subtitle: SizedBox(
                            height: 15,
                            width: 15,
                            child: Container(
                                color:
                                    const Color.fromARGB(255, 118, 181, 197)),
                          ),
                          trailing: Text(
                            NumberFormat.simpleCurrency(
                                    locale: 'vi-VN', decimalDigits: 0)
                                .format(hometo),
                            style: GoogleFonts.alata(fontSize: 20),
                          ),
                        ),
                        ListTile(
                          leading: Image.network(
                              'https://cdn-icons-png.flaticon.com/512/5824/5824775.png'),
                          title: Text(
                            'Làm đẹp',
                            style: GoogleFonts.alata(fontSize: 20),
                          ),
                          subtitle: SizedBox(
                            height: 15,
                            width: 15,
                            child: Container(
                                color: const Color.fromARGB(255, 30, 129, 176)),
                          ),
                          trailing: Text(
                            NumberFormat.simpleCurrency(
                                    locale: 'vi-VN', decimalDigits: 0)
                                .format(beautyto),
                            style: GoogleFonts.alata(fontSize: 20),
                          ),
                        ),
                        ListTile(
                          leading: Image.network(
                              'https://cdn-icons-png.flaticon.com/512/7294/7294965.png'),
                          title: Text(
                            'Thể dục thể thao',
                            style: GoogleFonts.alata(fontSize: 20),
                          ),
                          subtitle: Container(
                              width: 15,
                              height: 15,
                              color: const Color.fromARGB(255, 21, 76, 121)),
                          trailing: Text(
                            NumberFormat.simpleCurrency(
                                    locale: 'vi-VN', decimalDigits: 0)
                                .format(sportto),
                            style: GoogleFonts.alata(fontSize: 20),
                          ),
                        ),
                        ListTile(
                          leading: Image.network(
                              'https://cdn-icons-png.flaticon.com/512/7750/7750379.png'),
                          title: Text(
                            'Lương',
                            style: GoogleFonts.alata(fontSize: 20),
                          ),
                          subtitle: SizedBox(
                            height: 15,
                            width: 15,
                            child: Container(
                                color:
                                    const Color.fromARGB(255, 238, 238, 228)),
                          ),
                          trailing: Text(
                            NumberFormat.simpleCurrency(
                                    locale: 'vi-VN', decimalDigits: 0)
                                .format(salaryto),
                            style: GoogleFonts.alata(fontSize: 20),
                          ),
                        ),
                        ListTile(
                          leading: Image.network(
                              'https://cdn-icons-png.flaticon.com/512/6639/6639716.png'),
                          title: Text(
                            'Nguồn thu khác',
                            style: GoogleFonts.alata(fontSize: 20),
                          ),
                          subtitle: SizedBox(
                            height: 15,
                            width: 15,
                            child: Container(
                                color:
                                    const Color.fromARGB(255, 139, 233, 140)),
                          ),
                          trailing: Text(
                            NumberFormat.simpleCurrency(
                                    locale: 'vi-VN', decimalDigits: 0)
                                .format(otherto),
                            style: GoogleFonts.alata(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              );
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}
