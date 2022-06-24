import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EmployeeInOutProvider extends ChangeNotifier{

  late DateTime entryTimeNow;
  late DateTime exitTimeNow;
  DateTime? date;
  var inTime,outTime,diffrence;
  var duration;
  List<dynamic> entryExitData = [];


  getInOutData() {
    FirebaseFirestore.instance.collection("admin").doc(FirebaseAuth.instance.currentUser?.email).collection('InOutTime').get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        print(result.data());
          entryExitData.add(result.data());
          notifyListeners();
      });
      notifyListeners();
    });
  }

  currentDate(){
   entryTimeNow = DateTime.now();
    date = DateTime(entryTimeNow.year, entryTimeNow.month, entryTimeNow.day);
    notifyListeners();
  }
  entryTime(){
    entryTimeNow = DateTime.now();
    inTime = DateFormat.Hms().format(entryTimeNow);
   notifyListeners();
  }
  exitTIme(){
    exitTimeNow = DateTime.now();
    outTime = DateFormat.Hms().format(exitTimeNow);
   print(exitTimeNow);
    notifyListeners();
  }

  durationTime(){
   /* diffrence = exitTimeNow.difference(entryTimeNow);
    duration = DateFormat.Hm().format(diffrence) as Duration;
    print(duration);*/
    duration = exitTimeNow.difference(entryTimeNow);
    print(duration);
    notifyListeners();
  }

}