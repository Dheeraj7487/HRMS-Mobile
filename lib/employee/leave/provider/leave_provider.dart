import 'package:flutter/material.dart';

class LeaveProvider extends ChangeNotifier{

  DateTime leaveFromDate = DateTime.now();
  DateTime leaveToDate = DateTime.now();
  //TimeOfDay selectedTime = TimeOfDay(hour: 9, minute: 0);
  int countLeave = 0;
  int countHour = 0;
  String? fromTime,toTime;

 // String selectLeaveType = "";
  String? selectLeaveType = null;

  List<String> selectLeaveTypeItem = [
    'LWP',
    'Flexi Leave',
    'Leave',
  ];

  get getLeaveType {
    notifyListeners();
    return selectLeaveTypeItem;
  }

  get getLeave {
    notifyListeners();
    return selectLeaveType;
  }

  get getFromTime {
    notifyListeners();
    return fromTime;
  }

  get getToTime {
    notifyListeners();
    return toTime;
  }

  get getHour {
    notifyListeners();
    return countHour;
  }

  getFromLeave() {
    notifyListeners();
    return leaveFromDate;
  }

  countValueGet(){
    countLeave = leaveToDate.difference(leaveFromDate).inDays;
    //print(selectedTime.hour);
    notifyListeners();
  }

  /*onWillPop(){
    countLeave=0;
    fromTime = null;
    toTime = null;
    //selectLeaveType = null;
  }*/
}