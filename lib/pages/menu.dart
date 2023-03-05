import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../resource/style.dart';
import 'welcome.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({
    Key? key,
  }) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  // final dio = Dio();
  bool isClicked = true;
  bool isLoading = false;
  String? name;
  String? photo;
  String? email;
  Future getCurrentUserData() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    setState(() {
      name = googleSignInAccount!.displayName;
      email = googleSignInAccount.email;
      photo = googleSignInAccount.photoUrl;
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentUserData();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
                  'Tài khoản',
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
        body: ListView(
          children: [
            const SizedBox(
              height: 10,
            ),
            CircleAvatar(
                radius: 50,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(photo.toString()),
                )),
            const SizedBox(
              height: 30,
            ),
            Center(
              child: Column(
                children: [
                  Text(
                    name.toString(),
                    style: Style.headLineStyle1,
                  ),
                  Text(
                    email.toString(),
                    style: Style.headLineStyle2,
                  ),
                ],
              ),
            ),
            // GestureDetector(
            //   child: isClicked
            //       ? ListTile(
            //           leading: Image.asset('assets/icon/person.png'),
            //           title: Text(
            //             username.text,
            //             style: const TextStyle(fontSize: 20),
            //           ),
            //           subtitle: Text(
            //             email,
            //             style: const TextStyle(fontSize: 13),
            //           ),
            //           trailing: const Icon(Icons.edit),
            //         )
            //       : ListTile(
            //           leading: Image.asset('assets/icon/person.png'),
            //           title: Padding(
            //               padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
            //               child: Container(
            //                   decoration: BoxDecoration(
            //                       color: Colors.grey[200],
            //                       borderRadius: BorderRadius.circular(20)),
            //                   padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
            //                   child: TextFormField(
            //                       controller: username,
            //                       decoration: const InputDecoration(
            //                         border: InputBorder.none,
            //                       )))),
            //           trailing: GestureDetector(
            //             child: const Icon(Icons.check),
            //             onTap: () {
            //               updateUsernameData();
            //               setState(() {
            //                 isClicked = true;
            //               });
            //             },
            //           )),
            //   onTap: () {
            //     setState(() {
            //       isClicked = false;
            //     });
            //   },
            // ),
            const SizedBox(
              height: 30,
            ),
            // GestureDetector(
            //   child: ListTile(
            //     leading: Image.asset('assets/icon/padlock.png'),
            //     title: const Text(
            //       'Đổi mật khẩu',
            //       style: TextStyle(fontSize: 20),
            //     ),
            //     trailing: const Icon(
            //       Icons.navigate_next,
            //     ),
            //   ),
            //   onTap: () {
            //     Navigator.pop(context);
            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => const ChangePass()));
            //   },
            // ),
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              child: ListTile(
                leading: Image.asset('assets/icon/books.png'),
                title: const Text(
                  'Sổ nợ',
                  style: TextStyle(fontSize: 20),
                ),
                trailing: const Icon(
                  Icons.navigate_next,
                ),
              ),
              onTap: () {},
            ),
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              child: ListTile(
                leading: Image.asset('assets/icon/pig.png'),
                title: const Text(
                  'Đăng xuất',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              onTap: () {
                // FirebaseAuth.instance.signOut();
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(builder: (context) => const WelcomePage()),
                // );
                showDialog(
                    useRootNavigator: false,
                    context: context,
                    builder: (context) {
                      return Dialog(
                          backgroundColor: background1,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: SizedBox(
                            height: 150,
                            width: MediaQuery.of(context).size.width / 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Bạn muốn đăng xuất ?',
                                  style: TextStyle(fontSize: 18),
                                ),
                                const SizedBox(height: 30),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    ElevatedButton(
                                        style: agree,
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Đóng')),
                                    ElevatedButton(
                                        style: degree,
                                        onPressed: () async {
                                          await GoogleSignIn().signOut();
                                          await FirebaseAuth.instance.signOut();
                                          await FacebookAuth.instance.logOut();
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    WelcomePage()),
                                          );
                                        },
                                        child: const Text('Đăng xuất')),
                                  ],
                                )
                              ],
                            ),
                          ));
                    });
              },
            ),
          ],
        ));
  }
}
