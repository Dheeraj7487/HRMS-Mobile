import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_attendance_app/utils/app_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../../../firebase/firebase_collection.dart';

class AddEmployeeFireAuth {

  List<dynamic> employeeData = [];

  static Future<User?> registerEmployeeUsingEmailPassword({
    required String employeeName,
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
      await user!.updateDisplayName(employeeName);
      await user.reload();
      user = auth.currentUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        AppUtils.instance.showToast(toastMessage: "The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        AppUtils.instance.showToast(toastMessage: "The account already exists for that email.");
      }
    } catch (e) {
      print(e);
    }
    return user;
  }

  static Future<User?> signInEmployeeUsingEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        AppUtils.instance.showToast(toastMessage: 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided.');
        AppUtils.instance.showToast(toastMessage: 'Wrong password provided.');
      }
    }
    return user;
  }

  Future<void> addEmployee(
      {required String email,
        required String employeeName,
        required String mobile,
        required String dob,
        required String address,
        required String designation,
        required String department,
        required String branch,
        required String dateOfJoining,
        required String employmentType,
        required String exprience,
        required String manager,
        required String imageUrl,
        required String type}) async {
    DocumentReference documentReferencer =
    FirebaseCollection().employeeCollection.doc(email);

    Map<String, dynamic> data = <String, dynamic>{
      "email": email.toString(),
      "employeeName": employeeName.toString(),
      "mobile": mobile.toString(),
      "dob": dob.toString(),
      "address": address.toString(),
      "designation": designation.toString(),
      "department": department.toString(),
      "branch": branch.toString(),
      "dateofjoining": dateOfJoining.toString(),
      "employment_type": employmentType.toString(),
      "imageUrl": imageUrl.toString(),
      "exprience": exprience.toString(),
      "manager": manager.toString(),
      "type": 'Employee'
    };
    print('employee data=> $data');

    FirebaseCollection().employeeCollection.get().then((querySnapshot) {
      for (var result in querySnapshot.docs) {
        print(result.data());
        employeeData.add(result.data());
      }
    });
    await documentReferencer
        .set(data)
        .whenComplete(() => print("Added Employee Details"))
        .catchError((e) => print(e));
  }

}