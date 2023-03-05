import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moneymanager/BottomBar/main_page.dart';
import 'package:moneymanager/components/spenditem.dart';
import 'package:moneymanager/model/spend_model.dart';
import 'package:moneymanager/model/spendname_model.dart';
import 'package:moneymanager/resource/style.dart';

// ignore: must_be_immutable
class Transactions extends StatefulWidget {
  String value = 'Chọn nhóm';
  String url = '';
  bool? status;
  Transactions(
      {Key? key, required this.value, required this.url, required this.status})
      : super(key: key);

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  String _msgcost = '';
  String _msgcontent = '';
  DateTime selectedDate = DateTime.now();
  void postDetailsToFireStore() async {
    SpendModel spendModel = SpendModel();
    SpendItem spendItem = SpendItem();
    final auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    spendModel.contentname = widget.value;

    spendModel.cost = _costController.text.isEmpty
        ? 0
        : int.parse(_costController.text.toString());
    spendModel.date = selectedDate;
    spendModel.desc = _descController.text;
    spendModel.id = spendItem.id.toString();
    spendModel.url = widget.url;
    spendModel.status = widget.status;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('details')
        .doc()
        .set({
      'contentname': spendModel.contentname,
      'desc': spendModel.desc,
      'date': spendModel.date,
      'cost': spendModel.cost,
      'status': spendModel.status,
      'url': spendModel.url
    });

    Fluttertoast.showToast(msg: 'Thêm thẻ thành công!');
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
    // ignore: use_build_context_synchronously
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => MainPage(currentIndex: 0)));
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _costController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background1,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MainPage(currentIndex: 0)));
          },
        ),
        flexibleSpace: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Text('Thêm giao dịch', style: Style.headLineStyle1),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                if (widget.value == 'Chọn nhóm') {
                  setState(() {
                    _msgcontent = 'Hãy chọn nhóm';
                  });
                }
                if (_costController.text.isEmpty) {
                  setState(() {
                    _msgcost = 'Hãy nhập tiền';
                  });
                } else {
                  postDetailsToFireStore();
                }
              },
              child: Text(
                'Lưu',
                style: GoogleFonts.alata(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const GetSpendItem()));
                },
                child: ListTile(
                  leading: widget.url == ''
                      ? Image.asset('assets/icon/question.png')
                      : Image.network(widget.url),
                  title: Text(widget.value,
                      style: GoogleFonts.alata(fontSize: 20)),
                ),
              ),
            ),
            Text(_msgcontent, style: GoogleFonts.alata(color: Colors.red)),
            const Spacer(),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: ListTile(
                leading: Image.asset('assets/icon/shopping.png'),
                title: Container(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    //color: Colors.grey[300]
                  ),
                  child: TextFormField(
                    style: const TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Số tiền',
                      hintStyle: GoogleFonts.alata(
                        fontSize: 20,
                      ),
                    ),
                    validator: (value1) {
                      if (value1!.isEmpty) {
                        setState(() {
                          _msgcost = 'Tiền';
                        });
                      } else {
                        setState(() {
                          _msgcost = '';
                        });
                        return null;
                      }
                      return null;
                    },
                    controller: _costController,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
            ),
            Text(_msgcost, style: const TextStyle(color: Colors.red)),
            const Spacer(),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: ListTile(
                leading: Image.asset('assets/icon/calendar.png'),
                title: GestureDetector(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: Text("${selectedDate.toLocal()}".split(' ')[0],
                      style: GoogleFonts.alata(
                        fontSize: 20,
                      )),
                ),
              ),
            ),
            const Spacer(),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: ListTile(
                leading: Image.asset('assets/icon/qs.png'),
                title: Container(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    //color: Colors.grey[300]
                  ),
                  child: TextField(
                    style: const TextStyle(fontSize: 20),
                    maxLines: 1,
                    controller: _descController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Ghi chú',
                      hintStyle: GoogleFonts.alata(
                        fontSize: 20,
                      ),
                    ),
                    inputFormatters: const [
                      //LengthLimitingTextInputFormatter(50),
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(
              flex: 6,
            ),
          ],
        ),
      ),
    );
  }
}
