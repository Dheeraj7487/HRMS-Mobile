import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:get/get.dart';
import '../../admin/home/screen/admin_home_screen.dart';
import '../../employee/home/screen/employee_home_screen.dart';
import '../../utils/app_utils.dart';

class LoginProvider extends ChangeNotifier{

  //List<dynamic> loginData = [];
  String? userEmail;
  bool dataFetch = false;

  getSharedPreferenceData(String? email) {
    userEmail=email;
    notifyListeners();
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

      if (FirebaseAuth.instance.currentUser?.email == email) {
        if (FirebaseAuth.instance.currentUser?.displayName == 'Admin') {
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
        .catchError((e) => Get.snackbar('Reset Password', "failed sent a reset password link"));
  }
}