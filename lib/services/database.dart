//get Spend Details

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moneymanager/auth/userauth.dart';

class DataBaseMethod {
  DataBaseMethod._privateConstructor();
  static final DataBaseMethod _instance = DataBaseMethod._privateConstructor();
  static DataBaseMethod get instance => _instance;

  Future userObj() async {
    String? name;
    String? url;
    String? email;
    final UserCredential userCredential =
        await AuthService().signInWithGoogle();
    final User? user = userCredential.user;
    name = user!.displayName.toString();
    email = user.email.toString();
    url = user.photoURL.toString();
  }
  // Future<List<SpendModel>> getDetails() async {
  //   try {
  //     List<SpendModel> listNguonThuKhac = [];
  //     List<SpendModel> listAnUong = [];
  //     List<SpendModel> listTheDucTheThao = [];
  //     List<SpendModel> listThueNha = [];
  //     List<SpendModel> listDiChuyen = [];
  //     List<SpendModel> listLamDep = [];
  //     List<SpendModel> listLuong = [];
  //     SpendModel spendModel;
  //     await FirebaseFirestore.instance
  //         .collection('user')
  //         .doc(FirebaseAuth.instance.currentUser!.uid)
  //         .collection('details')
  //         .get()
  //         .then((QuerySnapshot querySnapshot) {
  //       for (var doc in querySnapshot.docs) {
  //         if (doc['contentname'] == 'Làm đẹp') {
  //           spendModel = SpendModel.fromMap(doc);
  //           listLamDep.add(spendModel);
  //         }
  //         if (doc['contentname'] == 'Ăn uống') {
  //           spendModel = SpendModel.fromMap(doc);
  //           listAnUong.add(spendModel);
  //         }
  //         if (doc['contentname'] == 'Thuê nhà') {
  //           spendModel = SpendModel.fromMap(doc);
  //           listThueNha.add(spendModel);
  //         }
  //         if (doc['contentname'] == 'Thể dục thể thao') {
  //           spendModel = SpendModel.fromMap(doc);
  //           listTheDucTheThao.add(spendModel);
  //         }
  //         if (doc['contentname'] == 'Di chuyển') {
  //           spendModel = SpendModel.fromMap(doc);
  //           listDiChuyen.add(spendModel);
  //         }
  //         if (doc['contentname'] == 'Nguồn thu khác') {
  //           spendModel = SpendModel.fromMap(doc);
  //           listNguonThuKhac.add(spendModel);
  //         }
  //         if (doc['contentname'] == 'Lương') {
  //           spendModel = SpendModel.fromMap(doc);
  //           listLuong.add(spendModel);
  //         }
  //       }
  //     });
  //     return Future<List<SpendModel>>.value([]);
  //   } catch (e) {
  //     return Future<List<SpendModel>>.value([]);
  //   }
  // }

  Future onclickDelete(id) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('details')
        .doc(id)
        .delete();
    Fluttertoast.showToast(msg: 'Xóa thành công');
  }
}
