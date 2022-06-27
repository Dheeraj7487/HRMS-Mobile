import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_attendance_app/employee/inOut/provider/employee_in_out_provider.dart';
import 'package:employee_attendance_app/mixin/button_mixin.dart';
import 'package:employee_attendance_app/utils/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmployeeInOutScreen extends StatefulWidget {
  const EmployeeInOutScreen({Key? key}) : super(key: key);

  @override
  State<EmployeeInOutScreen> createState() => _EmployeeInOutScreenState();
}

class _EmployeeInOutScreenState extends State<EmployeeInOutScreen> {
  bool buttonInOutDisable = false;

  final CollectionReference _mainCollection = FirebaseFirestore.instance
      .collection('employee')
      .doc(FirebaseAuth.instance.currentUser?.email)
      .collection('InOutTime');

  var adminRef = FirebaseFirestore.instance
      .collection("employee")
      .doc(FirebaseAuth.instance.currentUser!.email)
      .collection('InOutTime')
      .snapshots();

  late String inTime, outTime, date, duration;

  @override
  Widget build(BuildContext context) {

    Future<void> addInOutTime(
        {required String currentDate,
        required String inTime,
        required String outTime,
        required String duration}) async {
      DocumentReference documentReferencer = _mainCollection.doc(
          Provider.of<EmployeeInOutProvider>(context, listen: false)
              .date
              .toString()
              .replaceAll("00:00:00.000", ""));

      Map<String, dynamic> data = <String, dynamic>{
        "currentDate": currentDate.toString(),
        "inTime": inTime.toString(),
        "outTime": outTime.toString(),
        "duration": duration.toString(),
      };
      print('In Out Data=> $data');

      await documentReferencer
          .set(data)
          .whenComplete(() => print("Added In Out Data"))
          .catchError((e) => print(e));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.appColor,
        title: const Text('Employee In Out'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: buttonInOutDisable == true
                        ? null
                        : () {
                            snapshot.currentDate();
                            snapshot.entryTime();
                            buttonInOutDisable = true;
                            addInOutTime(
                                currentDate: snapshot.date
                                    .toString()
                                    .replaceAll("00:00:00.000", ""),
                                inTime: snapshot.inTime.toString(),
                                outTime: snapshot.outTime.toString(),
                                duration: snapshot.duration.toString());
                            snapshot.entryExitData.clear();
                          },
                    child: ButtonMixin().stylishButton(text: 'In'),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: buttonInOutDisable == false
                        ? null
                        : () {
                            snapshot.exitTIme();
                            snapshot.durationTime();
                            buttonInOutDisable = false;
                            addInOutTime(
                                currentDate: snapshot.date
                                    .toString()
                                    .replaceAll("00:00:00.000", ""),
                                inTime: snapshot.inTime.toString(),
                                outTime: snapshot.outTime.toString(),
                                duration: snapshot.duration.toString());
                            snapshot.entryExitData.clear();
                          },
                    child: ButtonMixin().stylishButton(text: 'Out'),
                  )
                ],
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
                  stream: adminRef,
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> streamSnapshot) {
                    if(streamSnapshot.connectionState == ConnectionState.waiting){
                      return const Center(child: CircularProgressIndicator());
                    }else{
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
                                  const EdgeInsets.only(top: 5, bottom: 5,left: 10,right: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                              //flex: 1,
                                              child: Text('${streamSnapshot.data?.docs[index]['currentDate']}',
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold)
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
                                              child: Text(
                                                'In Time',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold),
                                              )),
                                          Expanded(
                                              flex: 1,
                                              child: Text(streamSnapshot.data?.docs[index]['inTime'])),
                                          const Expanded(
                                              //flex: 1,
                                              child: Center(
                                                  child: Text(
                                                    'Out Time',
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold),
                                                  ))),
                                          Expanded(
                                              //flex: 1,
                                              child: Center(
                                                  child: Text(streamSnapshot.data?.docs[index]['outTime']== null ?  '' : streamSnapshot.data?.docs[index]['outTime']))),
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
                                                    fontWeight: FontWeight.bold),
                                              )),
                                          Expanded(
                                              flex: 1,
                                              child: Text(streamSnapshot.data?.docs[index]['duration']== null ? '' : streamSnapshot.data?.docs[index]['duration'])),
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
      ),
    );
  }
}
