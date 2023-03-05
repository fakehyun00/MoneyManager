import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';

import '../../resource/style.dart';

class PieChart extends StatefulWidget {
  const PieChart({super.key});

  @override
  State<PieChart> createState() => _PieChartState();
}

class _PieChartState extends State<PieChart> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream:
            ref.collection('users').doc(cur).collection('details').snapshots(),
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
            double spendingtotal =
                foodto + moveto + hometo + sportto + beautyto;
            double incometotal = salaryto + otherto;
            double foodpercent = (foodto / spendingtotal) * 100;
            double movepercent = (moveto / spendingtotal) * 100;
            double homepercent = (hometo / spendingtotal) * 100;
            double beautypercent = (beautyto / spendingtotal) * 100;
            double sportpercent = (sportto / spendingtotal) * 100;
            double otherpercent = (otherto / incometotal) * 100;
            double salarypercent = (salaryto / incometotal) * 100;
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // SizedBox(
                    //   width: MediaQuery.of(context).size.width / 3,
                    //   height: MediaQuery.of(context).size.width / 2.5,
                    //   child: DChartPie(
                    //     data: [
                    //       {'domain': 'Ăn uống', 'measure': foodpercent},
                    //       {'domain': 'Di chuyển', 'measure': movepercent},
                    //       {'domain': 'Thuê nhà', 'measure': homepercent},
                    //       {'domain': 'Làm đẹp', 'measure': beautypercent},
                    //       {'domain': 'Thể dục thể thao', 'measure': sportpercent}
                    //     ],
                    //     fillColor: (pieData, index) {
                    //       switch (pieData['domain']) {
                    //         case 'Ăn uống':
                    //           return const Color.fromARGB(
                    //             255,
                    //             153,
                    //             204,
                    //             255,
                    //           );
                    //         case 'Di chuyển':
                    //           return const Color.fromARGB(255, 102, 255, 255);
                    //         case 'Thuê nhà':
                    //           return const Color.fromARGB(255, 255, 255, 153);
                    //         case 'Làm đẹp':
                    //           return const Color.fromARGB(255, 255, 153, 153);
                    //         case 'Thể dục thể thao':
                    //           return const Color.fromARGB(255, 255, 153, 255);
                    //       }
                    //     },
                    //   ),
                    // ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      height: MediaQuery.of(context).size.width / 2,
                      child: DChartPie(
                        //donutWidth: 0,\
                        showLabelLine: false,
                        pieLabel: (pieData, index) {
                          switch (pieData['domain']) {
                            case 'Ăn uống':
                              return '${foodpercent.toStringAsFixed(1)}%';
                            case 'Di chuyển':
                              return '${movepercent.toStringAsFixed(1)}%';
                            case 'Thuê nhà':
                              return '${homepercent.toStringAsFixed(1)}%';
                            case 'Làm đẹp':
                              return '${beautypercent.toStringAsFixed(1)}%';
                            case 'Thể dục thể thao':
                              return '${sportpercent.toStringAsFixed(1)}%';
                            default:
                          }
                        },
                        data: [
                          {'domain': 'Ăn uống', 'measure': foodpercent},
                          {'domain': 'Di chuyển', 'measure': movepercent},
                          {'domain': 'Thuê nhà', 'measure': homepercent},
                          {'domain': 'Làm đẹp', 'measure': beautypercent},
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
                              return const Color.fromARGB(255, 102, 255, 255);
                            case 'Thuê nhà':
                              return const Color.fromARGB(255, 255, 255, 153);
                            case 'Làm đẹp':
                              return const Color.fromARGB(255, 255, 153, 153);
                            case 'Thể dục thể thao':
                              return const Color.fromARGB(255, 255, 153, 255);
                          }
                        },
                      ),
                    ),
                    SizedBox(
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
                          {'domain': 'Nguồn thu khác', 'measure': otherpercent},
                          {'domain': 'Lương', 'measure': salarypercent},
                        ],
                        fillColor: (pieData, index) {
                          switch (pieData['domain']) {
                            case 'Lương':
                              return const Color.fromARGB(
                                255,
                                153,
                                204,
                                255,
                              );
                            case 'Nguồn thu khác':
                              return const Color.fromARGB(255, 102, 255, 255);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                ListTile(
                  leading: Image.network(''),
                  title: const Text('Ăn uống'),
                  subtitle: SizedBox(
                    height: 15,
                    width: 15,
                    child: Container(
                        color: const Color.fromARGB(255, 102, 255, 255)),
                  ),
                  trailing: Text(foodto.toString()),
                ),
                ListTile(
                  leading: Image.network(''),
                  title: const Text('Di chuyển'),
                  subtitle: SizedBox(
                    height: 15,
                    width: 15,
                    child: Container(
                        color: const Color.fromARGB(255, 102, 255, 255)),
                  ),
                  trailing: Text(foodto.toString()),
                ),
                ListTile(
                  leading: Image.network(''),
                  title: const Text('Thuê nhà'),
                  subtitle: SizedBox(
                    height: 15,
                    width: 15,
                    child: Container(
                        color: const Color.fromARGB(255, 255, 255, 153)),
                  ),
                  trailing: Text(hometo.toString()),
                ),
                ListTile(
                  leading: Image.network(''),
                  title: const Text('Làm đẹp'),
                  subtitle: SizedBox(
                    height: 15,
                    width: 15,
                    child: Container(
                        color: const Color.fromARGB(255, 255, 153, 15)),
                  ),
                  trailing: Text(beautyto.toString()),
                ),
                ListTile(
                  leading: Image.network(''),
                  title: const Text('Thể dục thể thao'),
                  subtitle: SizedBox(
                    height: 15,
                    width: 15,
                    child: Container(
                        color: const Color.fromARGB(255, 255, 153, 255)),
                  ),
                  trailing: Text(sportto.toString()),
                ),
                ListTile(
                  leading: Image.network(''),
                  title: const Text('Lương'),
                  subtitle: SizedBox(
                    height: 15,
                    width: 15,
                    child: Container(
                        color: const Color.fromARGB(255, 153, 204, 255)),
                  ),
                  trailing: Text(salaryto.toString()),
                ),
                ListTile(
                  leading: Image.network(''),
                  title: const Text('Nguồn thu khác'),
                  subtitle: SizedBox(
                    height: 15,
                    width: 15,
                    child: Container(
                        color: const Color.fromARGB(255, 102, 255, 255)),
                  ),
                  trailing: Text(otherto.toString()),
                ),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}
