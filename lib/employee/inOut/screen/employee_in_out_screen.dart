import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_attendance_app/employee/inOut/auth/in_out_fire_auth.dart';
import 'package:employee_attendance_app/employee/inOut/provider/employee_in_out_provider.dart';
import 'package:employee_attendance_app/mixin/button_mixin.dart';
import 'package:employee_attendance_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../firebase/firebase_collection.dart';
import '../../../utils/app_fonts.dart';


class EmployeeInOutScreen extends StatefulWidget {
  const EmployeeInOutScreen({Key? key}) : super(key: key);

  @override
  State<EmployeeInOutScreen> createState() => _EmployeeInOutScreenState();
}

class _EmployeeInOutScreenState extends State<EmployeeInOutScreen> {
  bool buttonInOutDisable = false;
  String? inDate = "";
  String? inGetBtnPref;

  late String inTime, outTime, date, duration,inTimeVal;

  late String currentDate;
  late String currentDateFire;
  late String currentYearMonth;

 /* getInOutData() async{
    var querySnapshots = await InOutFireAuth().mainCollection.get();
    for (var snapshot in querySnapshots.docChanges) {
      currentDateFire = Provider.of<EmployeeInOutProvider>(context,listen: true).inOutDataList.last.currentDate;
      // currentDateFire = snapshot.doc.get("currentDate");
      currentDate = DateTime.now().toString().substring(0,10);
    }
  }*/

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<EmployeeInOutProvider>(context,listen: false).fetchInOutRecords();
    currentDate = DateTime.now().toString().substring(0,10);
    currentYearMonth = DateTime.now().toString().substring(0,7);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.appColor,
        title: const Text('Employee In Out',style: TextStyle(fontFamily: AppFonts.Medium),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Consumer<EmployeeInOutProvider>(builder: (_, snapshot, __) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Center(
                  child: Text('Manual In Out',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18,fontFamily: AppFonts.Medium)),
                ),
                const SizedBox(height: 10),
                StreamBuilder(
                    stream: FirebaseCollection().inOutCollection.doc(DateFormat('yyyy-MM-dd').format(DateTime.now())).snapshots(),
                    builder: (context,AsyncSnapshot<DocumentSnapshot<Object?>> streamSnapshot) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              snapshot.currentDate();
                              snapshot.entryTime();

                             /* if(currentDateFire == '2022-07-06'){
                                print('I am ==');
                                print(currentDate);
                                print(currentDateFire);
                              }
                              else{
                                print('I am not equal');
                                print(currentDate);
                                print(currentDateFire);
                              }*/

                              InOutFireAuth().addInOutTime(
                                 currentDate: snapshot.date
                                      .toString().substring(0,10),
                                  inTime: snapshot.inTime.toString(),
                                  outTime: '',
                                  duration: '00:00',
                                  yearMonth: DateFormat.yMMMM().format(DateTime.now()),
                              );

                              /*   final pref=await SharedPreferences.getInstance();
                                    pref.setString("employeeDate",snapshot.date
                                        .toString()
                                        .replaceAll("00:00:00.000", ""));*/
                              /*AppUtils.instance.setPref(PreferenceKey.boolKey,
                                  PreferenceKey.prefInDisableBTN, true);
                              AppUtils.instance.setPref(PreferenceKey.stringKey,
                                  PreferenceKey.prefInDisable,*/
                              /* final prefs = await SharedPreferences.getInstance();

                                      inGetBtnPref = prefs.getString("employeeDate");
                                      print('dsdfs=>$inGetBtnPref');
                                      DateTime date = DateTime.now();

                                      var date1 = DateFormat('yyyy-MM-dd').format(date);
                                    //   DateTime date1 =   DateTime(date.day, date.month, date.year);
                                  print('date=>$date');
                                  print('date1=>$date1');

                                  if(inGetBtnPref == date1){
                                        buttonInOutDisable = true;
                                      } else{
                                        buttonInOutDisable = false;
                                      }
*/
                            },
                            child: ButtonMixin().stylishButton(text: 'In',),
                          ),
                          const SizedBox(width: 20),
                          GestureDetector(
                            onTap:
                           // snapshot.date.toString().replaceAll("00:00:00.000", "") != currentDateVal ? null :
                                 () async{
                              snapshot.exitTIme();
                              snapshot.durationTime();
                              //getInOutData();
                              //   snapshot.entryTime();
                              snapshot.currentDate();

                           //   print('current Date ${currentDate} == $currentDateFire');

                              var querySnapshots = await InOutFireAuth().mainCollection.get();
                              for (var snapshot in querySnapshots.docChanges) {
                                inTimeVal = snapshot.doc.get("inTime");
                              //  print('inTime $inTimeVal');
                              }

                              InOutFireAuth().addInOutTime(
                                  currentDate: snapshot.date
                                      .toString()
                                      .toString().substring(0,10),
                                //  inTime: snapshot.inTime.toString(),
                                  inTime: inTimeVal,
                                  outTime: snapshot.outTime.toString(),
                                  yearMonth: DateFormat.yMMMM().format(DateTime.now()),
                                  duration: '${snapshot.entryExitHour.toString().length == 1 ? '0${snapshot.entryExitHour}' : snapshot.entryExitHour}:${snapshot.duration.toString()}');
                            },
                            child: ButtonMixin().stylishButton(text: 'Out'),
                          )
                        ],
                      );
                    }
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Center(
                    child: Text('Employee In Out List',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20,fontFamily: AppFonts.Medium)),
                  ),
                ),
                StreamBuilder(
                    stream: InOutFireAuth().mainCollection.where('yearMonth',isEqualTo: DateFormat.yMMMM().format(DateTime.now())).snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> streamSnapshot) {
                      if (streamSnapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator());
                      } else {
                        return ListView.builder(
                            itemCount: streamSnapshot.data!.docs.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Card(
                                  color: index.isOdd == true
                                      ? AppColor.platinumColor
                                      : AppColor.listingBgColor,
                                  child: Padding(
                                    padding:
                                    const EdgeInsets.only(top: 5, left: 10, right: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                                child: Text('${streamSnapshot.data?.docs[index]['currentDate']}',
                                                    style: const TextStyle(fontSize: 16,fontFamily: AppFonts.Medium)
                                                )),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            const Expanded(
                                                flex: 1,
                                                child: Text('In Time', style: TextStyle(fontFamily: AppFonts.Medium))),
                                            Expanded(flex: 1,
                                                child: Text(streamSnapshot.data?.docs[index]['inTime'],style: const TextStyle(fontFamily: AppFonts.Medium))),
                                            const Expanded(
                                              //flex: 1,
                                                child: Center(
                                                    child: Text(
                                                      'Out Time',
                                                      style: TextStyle(fontFamily: AppFonts.Medium),
                                                    ))),
                                            Expanded(
                                                child: Center(
                                                    child: Text(
                                                        streamSnapshot
                                                            .data
                                                            ?.docs[index]['outTime'] ?? '',style: const TextStyle(fontFamily: AppFonts.Medium)))),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            const Expanded(
                                                flex: 5,
                                                child: Text(
                                                  'Duration',
                                                  style: TextStyle(fontFamily: AppFonts.Medium),
                                                )),
                                            Expanded(
                                                flex: 1,
                                                child: Text(
                                                  streamSnapshot.data?.docs[index]['duration'] ?? ''
                                                ,style: const TextStyle(fontFamily: AppFonts.Medium))),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ));
                            });
                      }
                    })
              ],
            );
          })),
    );
  }
}