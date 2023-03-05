import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moneymanager/BottomBar/main_page.dart';
import 'package:moneymanager/auth/userauth.dart';

import '../resource/style.dart';

class WelcomePage extends StatefulWidget {
  WelcomePage({super.key});
  var userObj;
  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background1,
      body: Container(
        alignment: Alignment.center,
        //decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            const Spacer(
              flex: 2,
            ),
            Image.asset(
              'assets/background/bg.png',
              scale: 1.5,
            ),
            const Spacer(
              flex: 2,
            ),
            Text(
              'Quản lý tài chính hiệu quả',
              textAlign: TextAlign.center,
              style: Style.headLineStyle1,
            ),
            const SizedBox(
              height: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '- Giảm các khoản chi không cần thiết',
                  style: Style.headLineStyle2,
                ),
                const SizedBox(height: 10),
                Text(
                  '- Tiết kiệm hàng tháng',
                  style: Style.headLineStyle2,
                ),
                const SizedBox(height: 10),
                Text(
                  '- Quản lý tất cả ở một nơi',
                  style: Style.headLineStyle2,
                ),
              ],
            ),
            const Spacer(
              flex: 1,
            ),
            // GestureDetector(
            //     onTap: () {
            //       Navigator.pop(context);
            //       Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (context) => const SignUpPage()));
            //     },
            //     child: Container(
            //       decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(20),
            //           color: Colors.green),
            //       child: Container(
            //         width: 200,
            //         padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
            //         child: Text(
            //           'ĐĂNG KÝ MIỄN PHÍ',
            //           textAlign: TextAlign.center,
            //           style: GoogleFonts.alata(
            //               color: Colors.white,
            //               fontSize: 16,
            //               fontWeight: FontWeight.w600),
            //         ),
            //       ),
            //     )),
            // const Spacer(
            //   flex: 1,
            // ),
            // GestureDetector(
            //     onTap: () {
            //       Navigator.pop(context);
            //       Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (context) => const LoginPage()));
            //     },
            //     child: Container(
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(20),
            //         color: Colors.grey[200],
            //       ),
            //       child: Container(
            //         width: 200,
            //         padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
            //         child: Text(
            //           'ĐĂNG NHẬP',
            //           textAlign: TextAlign.center,
            //           style: GoogleFonts.alata(
            //               color: Colors.green.shade500,
            //               fontSize: 16,
            //               fontWeight: FontWeight.w600),
            //         ),
            //       ),
            //     )),
            // const Spacer(
            //   flex: 1,
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: () async {
                      await AuthService().signInWithGoogle().then((value) {
                        AuthService().postDetailsToFireStore();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MainPage(
                                      currentIndex: 0,
                                    )),
                            (route) => false);
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey[200],
                      ),
                      child: Container(
                          width: 60,
                          height: 60,
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: SvgPicture.asset(
                            'assets/icon/google.svg',
                          )),
                    )),
                const SizedBox(
                  width: 50,
                ),
                GestureDetector(
                    onTap: () {
                      AuthService().signInWithFacebook().then((value) {
                        AuthService().postDetailsToFireStore();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MainPage(
                                      currentIndex: 0,
                                    )),
                            (route) => false);
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey[200],
                      ),
                      child: Container(
                          width: 60,
                          height: 60,
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: SvgPicture.asset(
                            'assets/icon/facebook.svg',
                          )),
                    )),
              ],
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
