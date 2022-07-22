import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_attendance_app/firebase/firebase_collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/employee_in_out_provider.dart';

class InOutFireAuth{

  var mainCollection = FirebaseCollection().inOutCollection;

  var employeeInOutRef =FirebaseCollection().inOutCollection.snapshots();

  late String inTime, outTime, date, duration;

  Future<void> addInOutTime({required String currentDate,
    required String inTime,
    String? outTime,
    String? duration,
    required String yearMonth,
  }) async {
    DocumentReference documentReferencer = mainCollection.doc(DateTime.now().toString().substring(0,10));

    Map<String, dynamic> data = <String, dynamic>{
      "currentDate": currentDate.toString(),
      "inTime": inTime.toString(),
      "outTime": outTime.toString(),
      "duration": duration.toString(),
      "yearMonth": yearMonth,
    };
    print('In Out Data=> $data');

    await documentReferencer
        .set(data)
        .whenComplete(() => print("Added In Out Data"))
        .catchError((e) => print(e));
  }

}