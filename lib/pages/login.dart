// ignore_for_file: avoid_unnecessary_containers

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:moneymanager/BottomBar/main_page.dart';
import 'package:moneymanager/pages/welcome.dart';
import 'package:moneymanager/resource/style.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _msgU = '';
  String _msgP = '';
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  bool invisible = true;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background1,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        flexibleSpace: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Text(
                'Đăng Nhập',
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => WelcomePage()));
            }),
      ),
      body: ListView(
        children: [
          SizedBox(
              height: 200,
              child: Lottie.asset('assets/login.json', repeat: false)),
          Form(
            key: _formkey,
            child: Container(
              padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                //padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Container(
                        padding: const EdgeInsets.only(left: 20),
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(20)),
                        child: TextFormField(
                          validator: (value1) {
                            if (value1!.isEmpty) {
                              setState(() {
                                _msgU = 'Vui lòng nhập Email!';
                              });
                            } else {
                              setState(() {
                                _msgU = '';
                              });
                            }

                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Email',
                          ),
                        ),
                      ),
                    ),
                    Text(
                      _msgU,
                      style: const TextStyle(color: Colors.red),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Container(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(20)),
                        child: TextFormField(
                          validator: (value2) {
                            if (value2!.isEmpty) {
                              setState(() {
                                _msgP = 'Vui lòng nhập mật khẩu';
                              });
                            } else {
                              setState(() {
                                _msgP = '';
                              });
                            }

                            return null;
                          },
                          obscureText: invisible,
                          controller: _passwordController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Mật khẩu',
                              suffix: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      invisible = !invisible;
                                    });
                                  },
                                  child: Icon(
                                    invisible
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    size: 15,
                                  ))),
                        ),
                      ),
                    ),
                    Text(
                      _msgP,
                      style: const TextStyle(color: Colors.red),
                    ),
                    GestureDetector(
                        onTap: () {
                          signIn(
                              _emailController.text, _passwordController.text);
                        },
                        child: Container(
                          //height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.green,
                          ),
                          child: Container(
                            width: 200,
                            padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                            child: const Center(
                              child: Text(
                                'ĐĂNG NHẬP',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ),
                        )),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()));
                        },
                        child: const Text(
                          'Bạn chưa có tài khoản ?',
                          style: TextStyle(color: Colors.green),
                        ))
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void signIn(String email, String password) async {
    try {
      if (_formkey.currentState!.validate()) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        // ignore: use_build_context_synchronously
        showDialog(
            useRootNavigator: false,
            context: context,
            builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: [
                    SizedBox(
                      height: 150,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
                        child: Column(
                          children: [
                            Text(
                              'Đăng nhập thành công!',
                              style: GoogleFonts.alata(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: -95,
                      child: Lottie.asset('assets/successfull.json',
                          repeat: false),
                    ),
                  ],
                ),
              );
            });
        Timer(const Duration(seconds: 1), () {
          Navigator.pop(context);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => MainPage(currentIndex: 0)));
        });
      } else {
        showDialog(
            useRootNavigator: false,
            context: context,
            builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: [
                    SizedBox(
                      height: 150,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
                        child: Column(
                          children: [
                            Text(
                              'Tài khoản hoặc mật khẩu không đúng!',
                              style: GoogleFonts.alata(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: -95,
                      child: Lottie.asset('assets/failed.json',
                          repeat: false, height: 50, width: 50),
                    ),
                  ],
                ),
              );
            });
        Timer(const Duration(seconds: 2), () {
          Navigator.pop(context);
        });
      }
    } catch (e) {
      showDialog(
          useRootNavigator: false,
          context: context,
          builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [
                  SizedBox(
                    height: 150,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
                      child: Column(
                        children: [
                          Text(
                            'Lỗi kết nối!',
                            style: GoogleFonts.alata(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: -50,
                    child: Lottie.asset('assets/failed.json',
                        repeat: false, height: 100, width: 100),
                  ),
                ],
              ),
            );
          });
      Timer(const Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    }
  }
}
