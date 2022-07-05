import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/employee_in_out_provider.dart';

class InOutFireAuth{

  final CollectionReference _mainCollection = FirebaseFirestore.instance
      .collection('employee')
      .doc(FirebaseAuth.instance.currentUser?.email)
      .collection('InOutTime');

  var employeeInOutRef = FirebaseFirestore.instance
      .collection("employee")
      .doc(FirebaseAuth.instance.currentUser!.email)
      .collection('InOutTime')
      .snapshots();

  late String inTime, outTime, date, duration;

  Future<void> addInOutTime({required String currentDate,
    required String inTime,
    required String outTime,
    required String duration,
    required bool inOutCheck, required BuildContext context
  }) async {
    DocumentReference documentReferencer = _mainCollection.doc(
        Provider.of<EmployeeInOutProvider>(context, listen: false).date
            .toString().replaceAll("00:00:00.000", ""));

    Map<String, dynamic> data = <String, dynamic>{
      "currentDate": currentDate.toString(),
      "inTime": inTime.toString(),
      "outTime": outTime.toString(),
      "duration": duration.toString(),
      "inOutCheck": inOutCheck,
    };
    print('In Out Data=> $data');

    await documentReferencer
        .set(data)
        .whenComplete(() => print("Added In Out Data"))
        .catchError((e) => print(e));
  }

}