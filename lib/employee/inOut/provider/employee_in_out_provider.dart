import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EmployeeInOutProvider extends ChangeNotifier{

  late DateTime entryTimeNow;
  late DateTime exitTimeNow;
  DateTime? date;
  var inTime,outTime,diffrence;
  var duration;
  List<dynamic> entryExitData = [];

  currentDate(){
   entryTimeNow = DateTime.now();
    date = DateTime(entryTimeNow.year, entryTimeNow.month, entryTimeNow.day);
    notifyListeners();
  }
  entryTime(){
    entryTimeNow = DateTime.now();
    inTime = DateFormat.Hm().format(entryTimeNow);
   notifyListeners();
  }
  exitTIme(){
    exitTimeNow = DateTime.now();
    outTime = DateFormat.Hm().format(exitTimeNow);
   print(exitTimeNow);
    notifyListeners();
  }

  durationTime(){
   /* diffrence = exitTimeNow.difference(entryTimeNow);
    duration = DateFormat.Hm().format(diffrence) as Duration;
    print(duration);*/
    duration = exitTimeNow.difference(entryTimeNow);
    print(duration);
    //TimeOfDay dur = duration;

    notifyListeners();
  }

}