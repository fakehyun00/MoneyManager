import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:moneymanager/model/user_model.dart';
import 'package:moneymanager/pages/login.dart';
import 'package:moneymanager/pages/welcome.dart';
import 'package:rive/rive.dart';

import '../resource/style.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String _email = '';
  String _password = '';
  String _username = '';
  String _cpassword = '';
  FocusNode emailFocusNode = FocusNode();
  FocusNode userFocusNode = FocusNode();
  FocusNode passFocusNode = FocusNode();
  FocusNode cpassFocusNode = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  bool invisible = true;
  StateMachineController? controller;
  SMIInput<bool>? isChecking;
  SMIInput<double>? numLook;
  SMIInput<bool>? isHandsUp;
  SMIInput<bool>? trigSuccess;
  SMIInput<bool>? trigFail;
  void signUp(String email, String password) async {
    try {
      if (_formKey.currentState!.validate()) {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => {postDetailsToFireStore()});
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
                              'Tạo tài khoản thành công',
                              style: GoogleFonts.alata(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            )
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: -95,
                      child: Lottie.asset('assets/successfull.json',
                          repeat: false),
                    )
                  ],
                ),
              );
            });
      }
      // ignore: empty_catches
    } catch (e) {}
  }

  void postDetailsToFireStore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    UserModel userModel = UserModel();

    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.username = _usernameController.text;
    userModel.password = _passwordController.text;

    await firebaseFirestore
        .collection('users')
        .doc(user.uid)
        .set(userModel.toMap());

    // ignore: use_build_context_synchronously
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false);
  }

  @override
  void initState() {
    super.initState();
    emailFocusNode.addListener(emailFocus);
    passFocusNode.addListener(passFocus);
    userFocusNode.addListener(userFocus);
    cpassFocusNode.addListener(cpassFocus);
  }

  void emailFocus() {
    isChecking?.change(emailFocusNode.hasFocus);
  }

  void userFocus() {
    isChecking?.change(userFocusNode.hasFocus);
  }

  void passFocus() {
    isHandsUp?.change(passFocusNode.hasFocus);
  }

  void cpassFocus() {
    isHandsUp?.change(cpassFocusNode.hasFocus);
  }

  @override
  void dispose() {
    emailFocusNode.removeListener(emailFocus);
    userFocusNode.removeListener(userFocus);
    passFocusNode.removeListener(passFocus);

    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
                'Đăng Ký',
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
          Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 200,
                      height: 200,
                      child: RiveAnimation.asset(
                        'assets/bear.riv',
                        fit: BoxFit.fitHeight,
                        stateMachines: const ['Login Machine'],
                        onInit: (artboard) {
                          controller = StateMachineController.fromArtboard(
                              artboard, 'Login Machine');
                          if (controller == null) {
                            return;
                          }
                          artboard.addController(controller!);
                          isChecking = controller?.findInput('isChecking');
                          numLook = controller?.findInput('numLook');
                          isHandsUp = controller?.findInput('isHandsUp');
                          trigSuccess = controller?.findInput('trigSuccess');
                          trigFail = controller?.findInput('trigFail');
                        },
                      )),
                  // Text(
                  //   'ĐĂNG KÝ',
                  //   style: Style.headLineStyle1,
                  // ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                          child: Container(
                            padding: const EdgeInsets.only(left: 20),
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(20)),
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (value) {
                                numLook?.change(value.length.toDouble());
                              },
                              focusNode: emailFocusNode,
                              validator: (value) {
                                RegExp regExp = RegExp(
                                    r'^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]$');
                                if (value!.isEmpty) {
                                  setState(() {
                                    _email = 'Hãy nhập Email của bạn';
                                  });
                                }
                                if (!regExp.hasMatch(value)) {
                                  setState(() {
                                    _email = 'Hãy nhập đúng Email';
                                  });
                                } else {
                                  setState(() {
                                    _email = '';
                                  });
                                }

                                return null;
                              },
                              controller: _emailController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Email',
                              ),
                            ),
                          ),
                        ),
                        Text(
                          _email,
                          style: const TextStyle(color: Colors.red),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Container(
                            padding: const EdgeInsets.only(left: 20),
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(20)),
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  setState(() {
                                    _username = 'Vui lòng nhập Họ Tên';
                                  });
                                } else {
                                  setState(() {
                                    _username = '';
                                  });
                                }
                                return null;
                              },
                              focusNode: userFocusNode,
                              controller: _usernameController,
                              onChanged: (value) {
                                numLook?.change(value.length.toDouble());
                              },
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Họ và Tên',
                              ),
                            ),
                          ),
                        ),
                        Text(
                          _username,
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
                              focusNode: passFocusNode,
                              obscureText: invisible,
                              controller: _passwordController,
                              validator: (value) {
                                RegExp regExp = RegExp(r'^.{6,}$');
                                if (value!.isEmpty) {
                                  setState(() {
                                    _password = 'Hãy nhập mật khẩu của bạn';
                                  });
                                }
                                if (!regExp.hasMatch(value)) {
                                  setState(() {
                                    _password = 'Mật khẩu ít nhất 6 kí tự';
                                  });
                                } else {
                                  setState(() {
                                    _password = '';
                                  });
                                }
                                return null;
                              },
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
                                    ),
                                  )),
                            ),
                          ),
                        ),
                        Text(
                          _password,
                          style: const TextStyle(color: Colors.red),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Container(
                            padding: const EdgeInsets.only(left: 20),
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(20)),
                            child: TextFormField(
                                focusNode: cpassFocusNode,
                                validator: (value) {
                                  if (_confirmPasswordController.text !=
                                      _passwordController.text) {
                                    setState(() {
                                      _cpassword = 'Mật khẩu không trùng khớp';
                                    });
                                  } else {
                                    setState(() {
                                      _cpassword = '';
                                    });
                                  }
                                  return null;
                                },
                                obscureText: invisible,
                                controller: _confirmPasswordController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Nhập lại Mật khẩu',
                                )),
                          ),
                        ),
                        Text(
                          _cpassword,
                          style: const TextStyle(color: Colors.red),
                        ),
                        GestureDetector(
                            onTap: () {
                              signUp(_emailController.text,
                                  _passwordController.text);
                            },
                            child: Container(
                              // height: 30,
                              // width: 100,

                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.green),
                              child: Container(
                                width: 200,
                                padding:
                                    const EdgeInsets.fromLTRB(30, 10, 30, 10),
                                child: Text(
                                  'ĐĂNG KÝ MIỄN PHÍ',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.alata(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
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
                              'Bạn đã có tài khoản?',
                              style: TextStyle(color: Colors.green),
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
