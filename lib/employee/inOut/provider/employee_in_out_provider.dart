import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EmployeeInOutProvider extends ChangeNotifier{

  var date,entryTimeNow,exitTimeNow;
  var inTime,outTime,diffrence,duration;

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
    //TimeOfDay dur = duration;
    notifyListeners();
  }
}