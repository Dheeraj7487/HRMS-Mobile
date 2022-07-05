import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_attendance_app/employee/inOut/provider/employee_in_out_provider.dart';
import 'package:employee_attendance_app/mixin/button_mixin.dart';
import 'package:employee_attendance_app/utils/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../firebase/firebase_collection.dart';


class EmployeeInOutScreen extends StatefulWidget {
  const EmployeeInOutScreen({Key? key}) : super(key: key);

  @override
  State<EmployeeInOutScreen> createState() => _EmployeeInOutScreenState();
}

class _EmployeeInOutScreenState extends State<EmployeeInOutScreen> {
  bool buttonInOutDisable = false;
  String? inDate = "";
  //late String lockbtnpref = 'lastPressed';
  String? inGetBtnPref;

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

  /* lockButton() async {
    AppUtils.instance.setPref(
        PreferenceKey.boolKey, PreferenceKey.prefInDisable, true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime date = DateTime.now();
    //await prefs.setString('$lockbtnpref', date.toString());
    await AppUtils.instance.setPref(
        PreferenceKey.stringKey, PreferenceKey.prefInDisableBTN,
        buttonInOutDisable);
  }

  getSharedPreferenceData(String? prefbtn) {
    inBtnPref = prefbtn;
  }

  Future<dynamic> addDaySherePref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var date = DateTime.parse(AppUtils.instance.getPreferenceValueViaKey(
        PreferenceKey.prefInDisableBTN)).add(Duration(hours: 24));
    //var date= DateTime.parse(prefs.getString(lockbtnpref)).add(Duration(hours: 12));

    if (date.isBefore(DateTime.now())) {
      buttonInOutDisable = false;
    }
    else {
      buttonInOutDisable = true;
    }
  }

  getPreferenceData() async {
    buttonInOutDisable = await AppUtils.instance.getPreferenceValueViaKey(
        PreferenceKey.prefInDisableBTN) ?? false;
    inBtnPref = await AppUtils.instance.getPreferenceValueViaKey(
        PreferenceKey.prefInDisable) ?? "";
    setState(() {});
    if (buttonInOutDisable) {
      getSharedPreferenceData(inBtnPref);
    }}
*/
  @override
  Widget build(BuildContext context) {
    Future<void> addInOutTime({required String currentDate,
      required String inTime,
      required String outTime,
      required String duration,
      required bool inOutCheck
    }) async {
      DocumentReference documentReferencer = _mainCollection.doc(
          Provider
              .of<EmployeeInOutProvider>(context, listen: false)
              .date
              .toString()
              .replaceAll("00:00:00.000", ""));

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

    var date = DateTime.now();
    var currentDate = DateTime(date.year, date.month, date.day).toString();
    //var currentDate = DateTime(date.year, date.month, date.day).toString();


    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.appColor,
        title: const Text('Employee In Out'),
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
                      style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(height: 10),
                StreamBuilder(
                    stream: FirebaseCollection().inOutCollection.doc(DateFormat('yyyy-MM-dd').format(DateTime.now())).snapshots(),
                    builder: (context,AsyncSnapshot<DocumentSnapshot<Object?>> streamSnapshot) {
                      // Map<String, dynamic> data = streamSnapshot.data!.data() as Map<String, dynamic>;
                      //   print("data=> $data");
                      /*DateTime now = DateTime.now();
                      String formattedTime = DateFormat('yyyy-MM-dd').format(now);
                      print(formattedTime);
*/
                      print(
                          FirebaseCollection().inOutCollection.doc(
                              DateFormat('yyyy-MM-dd').format(DateTime.now())));
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap:
                            //buttonInOutDisable == false ? null :
                                () async {
                              //    print(data['inOutCheck']);
                              snapshot.currentDate();
                              snapshot.entryTime();
                              addInOutTime(
                                  currentDate: snapshot.date
                                      .toString()
                                      .replaceAll("00:00:00.000", ""),
                                  inTime: snapshot.inTime.toString(),
                                  outTime: snapshot.outTime.toString(),
                                  duration: snapshot.duration.toString(),
                                  inOutCheck: true
                              );

                              /*   final pref=await SharedPreferences.getInstance();
                                    pref.setString("employeeDate",snapshot.date
                                        .toString()
                                        .replaceAll("00:00:00.000", ""));*/

                              /*AppUtils.instance.setPref(PreferenceKey.boolKey,
                                  PreferenceKey.prefInDisableBTN, true);
                              AppUtils.instance.setPref(PreferenceKey.stringKey,
                                  PreferenceKey.prefInDisable,*/
                              //  snapshot.inTime.toString());
                              //getSharedPreferenceData(snapshot.inTime.toString());
                              // addDaySherePref();
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
                            child: ButtonMixin().stylishButton(text: 'In'),
                          ),
                          const SizedBox(width: 20),
                          GestureDetector(
                            onTap: buttonInOutDisable == true
                                ? null
                                : () {
                              snapshot.exitTIme();
                              snapshot.durationTime();
                              //    buttonInOutDisable = false;
                              addInOutTime(
                                  currentDate: snapshot.date
                                      .toString()
                                      .replaceAll("00:00:00.000", ""),
                                  inTime: snapshot.inTime.toString(),
                                  outTime: snapshot.outTime.toString(),
                                  duration: snapshot.duration.toString(), inOutCheck: true);
                            },
                            child: ButtonMixin().stylishButton(text: 'Out'),
                          )
                        ],
                      );
                    }
                ),
                const SizedBox(height: 10),
                const Card(
                  child: Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Center(
                      child: Text('Employee In Out List',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 24)),
                    ),
                  ),
                ),
                StreamBuilder(
                    stream: employeeInOutRef,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot<Map<String,
                            dynamic>>> streamSnapshot) {
                      if (streamSnapshot.connectionState ==
                          ConnectionState.waiting) {
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
                                      ? AppColor.backgroundColor
                                      : AppColor.listingBgColor,
                                  child: Padding(
                                    padding:
                                    const EdgeInsets.only(top: 5,
                                        bottom: 5,
                                        left: 10,
                                        right: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      mainAxisAlignment: MainAxisAlignment
                                          .start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              //flex: 1,
                                                child: Text(
                                                    '${streamSnapshot.data
                                                        ?.docs[index]['currentDate']}',
                                                    style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight: FontWeight
                                                            .bold)
                                                )),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          mainAxisAlignment: MainAxisAlignment
                                              .start,
                                          children: [
                                            const Expanded(
                                                flex: 1,
                                                child: Text(
                                                  'In Time',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight
                                                          .bold),
                                                )),
                                            Expanded(
                                                flex: 1,
                                                child: Text(
                                                    streamSnapshot.data
                                                        ?.docs[index]['inTime'])),
                                            const Expanded(
                                              //flex: 1,
                                                child: Center(
                                                    child: Text(
                                                      'Out Time',
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .bold),
                                                    ))),
                                            Expanded(
                                              //flex: 1,
                                                child: Center(
                                                    child: Text(
                                                        streamSnapshot.data
                                                            ?.docs[index]['outTime'] ==
                                                            null
                                                            ? ''
                                                            : streamSnapshot
                                                            .data
                                                            ?.docs[index]['outTime']))),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          children: [
                                            const Expanded(
                                                flex: 1,
                                                child: Text(
                                                  'Duration',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight
                                                          .bold),
                                                )),
                                            Expanded(
                                                flex: 1,
                                                child: Text(
                                                    streamSnapshot.data
                                                        ?.docs[index]['duration'] ==
                                                        null
                                                        ? ''
                                                        : streamSnapshot.data
                                                        ?.docs[index]['duration'])),
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