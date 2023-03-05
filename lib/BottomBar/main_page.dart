import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moneymanager/pages/home.dart';
import 'package:moneymanager/pages/menu.dart';
import 'package:moneymanager/pages/transaction.dart';

//ignore: must_be_immutable
class MainPage extends StatefulWidget {
  MainPage({super.key, required this.currentIndex});
  int currentIndex = 0;
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  DateTime backPressedTime = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  List<Widget> pages = <Widget>[
    const HomePage(),
    Transactions(
      url: '',
      status: null,
      value: 'Chọn nhóm',
    ),
    const MenuPage()
  ];
  int currentIndex = 0;
  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          body: pages[currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            onTap: onTap,
            currentIndex: currentIndex,
            //elevation: 0,
            showUnselectedLabels: true,
            selectedItemColor: Colors.black87,
            unselectedItemColor: Colors.grey.withOpacity(1),
            items: const [
              BottomNavigationBarItem(
                label: 'Tổng quan',
                icon: Icon(Icons.apps),
              ),
              BottomNavigationBarItem(
                label: '',
                icon: Icon(
                  Icons.add_circle,
                  size: 40,
                ),
              ),
              BottomNavigationBarItem(
                label: 'Tài khoản',
                icon: Icon(Icons.person),
              ),
            ],
          ),
        ),
        onWillPop: () => _onBackButtonDoubleClicked(context));
  }

  Future<bool> _onBackButtonDoubleClicked(BuildContext context) async {
    final diff = DateTime.now().difference(backPressedTime);
    if (diff >= const Duration(seconds: 2)) {
      Fluttertoast.showToast(msg: 'Nhấn lần nữa để thoát', fontSize: 18);
      return false;
    } else {
      SystemNavigator.pop(animated: true);
      return true;
    }
  }
}
