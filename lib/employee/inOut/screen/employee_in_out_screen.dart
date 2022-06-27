import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_attendance_app/employee/inOut/provider/employee_in_out_provider.dart';
import 'package:employee_attendance_app/mixin/button_mixin.dart';
import 'package:employee_attendance_app/utils/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmployeeInOutScreen extends StatefulWidget {
  EmployeeInOutScreen({Key? key}) : super(key: key);

  @override
  State<EmployeeInOutScreen> createState() => _EmployeeInOutScreenState();
}

class _EmployeeInOutScreenState extends State<EmployeeInOutScreen> {
  bool buttonInOutDisable = false;

  final CollectionReference _mainCollection = FirebaseFirestore.instance
      .collection('admin')
      .doc(FirebaseAuth.instance.currentUser?.email)
      .collection('InOutTime');
  List<dynamic> inOutData = [];
  late String inTime, outTime, date, duration;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //print('List length => ${entryExitData.length}');
    print('List length1 => ${inOutData.length}');
  }

  @override
  Widget build(BuildContext context) {
    // Provider.of<EmployeeInOutProvider>(context).getInOutData();

    var adminRef =
    FirebaseFirestore.instance.collection("admin").doc(FirebaseAuth.instance.currentUser!.uid).snapshots();


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

      FirebaseFirestore.instance.collection(
          Provider.of<EmployeeInOutProvider>(context, listen: false)
              .date
              .toString()
              .replaceAll("00:00:00.000", ""))
        ..get().then((querySnapshot) {
          for (var result in querySnapshot.docs) {
            print(result.data());
            setState(() {
              inOutData.add(result.data());
            });
          }
        });
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
                            print(inOutData);
                            buttonInOutDisable = true;
                            addInOutTime(
                                currentDate: snapshot.date
                                    .toString()
                                    .replaceAll("00:00:00.000", ""),
                                inTime: snapshot.inTime.toString(),
                                outTime: snapshot.outTime.toString(),
                                duration: snapshot.duration.toString());
                            snapshot.entryExitData.clear();
                            snapshot.getInOutData();
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
                            snapshot.getInOutData();
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
              //StreamBuilder(
              StreamBuilder(
                  //stream: FirebaseFirestore.instance.collection('admin').snapshots(),
                  stream: adminRef,
                    //future: adminRef.doc(FirebaseAuth.instance.currentUser?.email).get(),
                  //collection('InOutTime').doc('2022-06-23').get(),
                  builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                    //Map<String, dynamic> documentData = futureSnapshot.data;
                   // Map<String, dynamic> data = futureSnapshot.data as Map<String, dynamic>;
                    return ListView.builder(
                        itemCount: snapshot.data?.data()?.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          //DocumentReference documentReference = futureSnapshot.data.docs[index];
                          return Text("${snapshot.data!.id}");
                         /* return Card(
                              color: index.isOdd == true
                                  ? AppColor.backgroundColor
                                  : AppColor.listingBgColor,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 5, bottom: 5),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        const Expanded(
                                            flex: 1,
                                            child: Center(child: Text('Date'))),
                                        Expanded(
                                            flex: 1,
                                            child: Center(
                                                child: Text(
                                              snapshot.date == null
                                                  ? ""
                                                  : snapshot
                                                          .entryExitData[index]
                                                      ['currentDate'],
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ))),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const Expanded(
                                            flex: 1,
                                            child: Center(
                                                child: Text(
                                              'In Time',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ))),
                                        Expanded(
                                            flex: 1,
                                            child: Center(
                                                child: Text(snapshot.inTime ==
                                                        null
                                                    ? ""
                                                    : snapshot.entryExitData[
                                                        index]['inTime']))),
                                        const Expanded(
                                            flex: 1,
                                            child: Center(
                                                child: const Text(
                                              'Out Time',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ))),
                                        Expanded(
                                            flex: 1,
                                            child: Center(
                                                child: Text(snapshot.outTime ==
                                                        null
                                                    ? ""
                                                    : snapshot.entryExitData[
                                                        index]['outTime']))),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        const Expanded(
                                            flex: 1,
                                            child: const Center(
                                                child: const Text(
                                              'Duration',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ))),
                                        Expanded(
                                            flex: 1,
                                            child: Center(
                                                child: Text(snapshot.duration ==
                                                        null
                                                    ? ""
                                                    : snapshot.entryExitData[
                                                        index]['duration']))),
                                      ],
                                    ),
                                  ],
                                ),
                              ));*/
                        });
                  })
            ],
          );
        })),
      ),
    );
  }
}
