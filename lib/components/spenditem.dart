import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moneymanager/pages/transaction.dart';
import 'package:moneymanager/resource/style.dart';

class GetSpendItem extends StatefulWidget {
  const GetSpendItem({super.key});

  @override
  State<GetSpendItem> createState() => _GetSpendItemState();
}

class _GetSpendItemState extends State<GetSpendItem> {
  String? value;
  String? url;
  bool? status;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background1,
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.maybePop(context);
          },
          color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Danh Sách Chi Tiêu',
          style: GoogleFonts.alata(fontSize: 30, color: Colors.black),
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('spendname')
              .orderBy('status', descending: true)
              .snapshots(),
          builder: (_, snapshot) {
            if (snapshot.hasError) {
              return const Text('Error');
            }
            if (snapshot.hasData) {
              final doc = snapshot.data!.docs;
              return ListView.builder(
                  itemCount: doc.length,
                  itemBuilder: (_, i) {
                    final data = doc[i].data();
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: ListTile(
                              leading: Image.network(data['url']),
                              title: Text(
                                data['content'],
                                style: TextStyle(
                                    color: data['status'] == true
                                        ? Colors.red
                                        : Colors.green),
                              )),
                        ),
                        onTap: () {
                          value = data['content'];
                          url = data['url'];
                          status = data['status'];
                          Navigator.pop(context);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Transactions(
                                    url: url.toString(),
                                    status: status,
                                    value: value.toString(),
                                  )));
                        },
                      ),
                    );
                  });
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}
