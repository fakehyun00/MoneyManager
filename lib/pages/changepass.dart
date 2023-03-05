import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moneymanager/BottomBar/main_page.dart';
import 'package:moneymanager/pages/login.dart';

class ChangePass extends StatefulWidget {
  const ChangePass({super.key});

  @override
  State<ChangePass> createState() => _ChangePassState();
}

class _ChangePassState extends State<ChangePass> {
  String _msgC = '';
  String _msgP = '';
  String _msgP2 = '';
  var newPassword = '';
  var curPass = '';
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  bool invisible = true;
  final _formKey = GlobalKey<FormState>();
  changePass() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'password': newPassword});
      await FirebaseAuth.instance.currentUser!.updatePassword(newPassword);
      FirebaseAuth.instance.signOut();
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
      Fluttertoast.showToast(msg: 'Đổi mật khẩu thành công!');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Something went wrong!');
    }
  }

  Future getCurrentUserData() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((snapshot) async {
      if (snapshot.exists) {
        setState(() {
          // Your state change code goes here
          curPass = snapshot.data()!['password'];
        });

        // setState(() {});
      }
    });
  }

  @override
  void dispose() {
    // ignore: todo
    super.dispose();
    _passwordController.dispose();
  }

  @override
  void initState() {
    super.initState();
    getCurrentUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: BackButton(
        onPressed: () {
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MainPage(currentIndex: 2)));
        },
      )),
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.all(50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Đổi mật khẩu',
                style: TextStyle(fontSize: 40),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text('Nhập mật khẩu hiện tại'),
              const SizedBox(
                height: 10,
              ),
              Container(
                  padding: const EdgeInsets.only(left: 30),
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20)),
                  child: TextFormField(
                      validator: (value) {
                        if (value != curPass) {
                          setState(() {
                            _msgC = 'Mật khẩu không trùng khớp';
                          });
                        }
                        if (value == '') {
                          setState(() {
                            _msgC = 'Vui lòng nhập mật khẩu';
                          });
                        }
                        return null;
                      },
                      controller: _currentPasswordController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ))),
              Text(_msgC),
              const SizedBox(
                height: 20,
              ),
              const Text('Nhập mật khẩu mới'),
              const SizedBox(
                height: 10,
              ),
              Container(
                  padding: const EdgeInsets.only(left: 30),
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20)),
                  child: TextFormField(
                      validator: (value) {
                        RegExp regExp = RegExp(r'^.{6,}$');
                        if (value!.isEmpty) {
                          setState(() {
                            _msgP = 'Hãy nhập mật khẩu của bạn';
                          });
                        }
                        if (!regExp.hasMatch(value)) {
                          setState(() {
                            _msgP = 'Mật khẩu ít nhất 6 kí tự';
                          });
                        }
                        return null;
                      },
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ))),
              Text(_msgP),
              const SizedBox(
                height: 10,
              ),
              const Text('Nhập lại mật khẩu mới'),
              const SizedBox(
                height: 10,
              ),
              Container(
                  padding: const EdgeInsets.only(left: 30),
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20)),
                  child: TextFormField(
                      validator: (value) {
                        if (_confirmPasswordController.text !=
                            _passwordController.text) {
                          setState(() {
                            _msgP2 = 'Mật khẩu không trùng khớp';
                          });
                        }
                        return null;
                      },
                      controller: _confirmPasswordController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ))),
              Text(_msgP2),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                  onTap: () {
                    // showAboutDialog(
                    //     context: context, children: [const Text('Clicked')]);
                    if (_formKey.currentState!.validate()) {
                      if (_currentPasswordController.text == curPass) {
                        setState(() {
                          newPassword = _passwordController.text;
                        });
                        changePass();
                      }
                    }
                  },
                  child: Container(
                    // height: 30,
                    // width: 100,

                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.green),
                    child: Container(
                      width: 200,
                      padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                      child: const Text(
                        'ĐĂNG KÝ MIỄN PHÍ',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
