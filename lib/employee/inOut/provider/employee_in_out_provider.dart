import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_attendance_app/employee/inOut/model/in_out_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EmployeeInOutProvider extends ChangeNotifier{

  var date,entryTimeNow,exitTimeNow;
  var inTime,outTime,diffrence;
  var duration;
  List<InOutModel> inOutDataList = [];

  inOutMapRecords(QuerySnapshot<Map<dynamic, dynamic>> records) async{
    var _list = records.docs.map(
            (item) => InOutModel(
          currentDate : item['currentDate'],
              inTime: item['inTime'],
          outTime: item['outTime'], duration: item['duration'],
        )).toList();
    inOutDataList = _list.cast<InOutModel>();
    notifyListeners();
  }


  fetchInOutRecords() async {
    var inOutRecords = await FirebaseFirestore.instance.collection('employee').
    doc(FirebaseAuth.instance.currentUser!.email).collection('InOutTime').get();
    //print('cvcv ${inOutRecords}');
    inOutMapRecords(inOutRecords);
  }

  currentDate(){
    entryTimeNow = DateTime.now();
    date = DateTime(entryTimeNow.year, entryTimeNow.month, entryTimeNow.day);
    notifyListeners();
  }
  entryTime(){
    entryTimeNow = DateTime.now();
    inTime = DateFormat('kk:mm').format(entryTimeNow);
    // inTime = DateFormat.Hm().format(entryTimeNow);
    //inOutDataList.last.currentDate;
    notifyListeners();
  }
  exitTIme(){
    exitTimeNow = DateTime.now();
    outTime = DateFormat('kk:mm').format(exitTimeNow);
   // print(exitTimeNow);
    //inOutDataList.last.currentDate;
    notifyListeners();
  }

  durationTime()async{
    var x= FirebaseFirestore.instance
        .collection('employee')
        .doc(FirebaseAuth.instance.currentUser?.email).collection('InOutTime');
    var collection = FirebaseFirestore.instance.collection('employee').doc(FirebaseAuth.instance.currentUser?.email).collection('InOutTime');
    var querySnapshots = await collection.get();
    for (var snapshot in querySnapshots.docChanges) {
      var date = snapshot.doc.get("inTime");
      print("234523v346g345fg543 ${date}");

      DateTime tempDate = DateFormat('kk:mm').parse('${date}');
      var dateFormatData = DateFormat('yyyy-MM-dd').format(DateTime.now());

      print('tempDate => ${tempDate.toString().replaceAll('1970-01-01', dateFormatData)}');
      var dataDate1 = tempDate.toString().replaceAll('1970-01-01', dateFormatData);
      print('data date 1 => $dataDate1');

      DateTime dateTime = DateTime.parse('$dataDate1');
     // DateTime dateFormat = DateFormat('kk:mm').parse('${dataDate1}');
      print('dfdfdfdf ======= $dateTime');

      Duration duration1 = exitTimeNow.difference(dateTime);
      print('Duration 1 Date => $duration1');
      print('Duration 1 Date => $exitTimeNow');
      print('Duration 1 Date => $dataDate1');

      duration = duration1.toString().substring(0,5);
    }
    notifyListeners();
  }
}
