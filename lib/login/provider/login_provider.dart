
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_attendance_app/login/model/admin_model.dart';
import 'package:employee_attendance_app/login/model/employeeModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../admin/home/screen/admin_home_screen.dart';
import '../../employee/home/screen/employee_home_screen.dart';
import '../../utils/app_utils.dart';
import 'loading_provider.dart';

class LoginProvider extends ChangeNotifier{

  //List<dynamic> loginData = [];
  String? userEmail;
  bool dataFetch = false;
  List<AdminModel> adminDataList = [];
  List<EmployeeModel> emplyeeDataList = [];
  List<dynamic> adminData = [];
  late BuildContext context;
  final CollectionReference _mainCollection = FirebaseFirestore.instance.collection('admin');


  getSharedPreferenceData(String? email) {
    userEmail=email;
    notifyListeners();
  }

  adminMapRecords (QuerySnapshot<Map<String, dynamic>> records) {
    var _list = records.docs.map(
    (item) => AdminModel(companyName: item['companyName'], email: item['email'],mobile: item['mobile'], type: item['type'])).toList();
    adminDataList = _list.cast<AdminModel>();
    print(_list);
    print(adminDataList[0].email);
    notifyListeners();
  }

  employeeMapRecords (QuerySnapshot<Map<String, dynamic>> records) {
    var _list = records.docs.map(
            (data) => EmployeeModel(address: data['address'], branch: data['branch'], dateofjoining: data['dateofjoining'],
                department: data['department'], designation: data['designation'], email: data['email'],
                dob: data['dob'], employeeName: data['employeeName'], employmentType: data['employment_type'],
                exprience: data['exprience'], imageUrl: data['imageUrl'], mobile: data['mobile'], type: data['type'])).toList();
    emplyeeDataList = _list.cast<EmployeeModel>();
    print(_list);
    print(emplyeeDataList[0].email);
    notifyListeners();
  }

  fetchRecords() async {
    var adminRecords = await FirebaseFirestore.instance.collection('admin').get();
    var employeeRecords = await FirebaseFirestore.instance.collection('employee').get();
    print(adminRecords);
    adminMapRecords(adminRecords);
    employeeMapRecords(employeeRecords);
  }

  Future<void> signUpAdmin(
      {required String email,
        required String companyName,
        required String mobile,
        required String type}) async {
    DocumentReference documentReferencer = _mainCollection.doc(email);

    Map<String, dynamic> data = <String, dynamic>{
      "email": email.toString(),
      "companyName": companyName.toString(),
      "mobile": mobile.toString(),
      "type": 'Admin',
    };
    print('employee data=> $data');

    FirebaseFirestore.instance.collection("admin").get().then((querySnapshot) {
      for (var result in querySnapshot.docs) {
        print(result.data());
        adminData.add(result.data());
      }
    });
    await documentReferencer
        .set(data)
        .whenComplete(() => {
      // EasyLoading.dismiss()
      Provider.of<LoadingProvider>(context,listen: false).stopLoading()
    })
        .catchError((e) => print(e));
  }

  getData(String email) {
   /* final key = encrypt.Key.fromUtf8('my 32 length key................');
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
*/
   /* FirebaseFirestore.instance.collection("admin").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        print(result.data());
          loginData.add(result.data());
          notifyListeners();
      });*/
      //for (int i = 0; i < adminDataList.length; i++){
      //  print(adminDataList[i].email);
        if (FirebaseAuth.instance.currentUser!.email == email) {
          if (FirebaseAuth.instance.currentUser!.displayName == 'Admin') {
            Get.offAll(AdminHomeScreen());
            AppUtils.instance.showToast(toastMessage: "Login Successfully");
            print('Admin login');
            notifyListeners();
          }
          else {
            Get.offAll(EmployeeHomeScreen());
            AppUtils.instance.showToast(toastMessage: "Login Successfully");
            print('Employee login');
            notifyListeners();
          }
      //  }

        /* for (int i = 0; i < loginData.length; i++) {
        if (loginData[i]['email'] == email) {
          if(loginData[i]['employement_type'] == 'Admin'){
            Get.off(AdminHomeScreen());
            AppUtils.instance.showToast(toastMessage: "Login Successfully");
            print('admin login');
            notifyListeners();
          }
          else{
            AppUtils.instance.showToast(toastMessage: "No user found for that email");
          }
        }
      }*/
      }
  }

  Future resetPassword({required String email}) async {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: email).then((value) => Get.snackbar('Reset Password', 'sent a reset password link on your gmail account'))
        .catchError((e) => Get.snackbar('Reset Password', "No user found that email"));
  }
}