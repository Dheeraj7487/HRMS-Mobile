import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_attendance_app/employee/reports/openpdf/open_pdf_present.dart';
import 'package:employee_attendance_app/employee/reports/pdfview/pdfview_in_out_present.dart';
import 'package:employee_attendance_app/employee/reports/provider/reports_provider.dart';
import 'package:employee_attendance_app/utils/app_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../firebase/firebase_collection.dart';
import '../../../utils/app_colors.dart';
import '../../inOut/auth/in_out_fire_auth.dart';

class EmployeeInOutPresent extends StatefulWidget {
  const EmployeeInOutPresent({Key? key}) : super(key: key);

  @override
  State<EmployeeInOutPresent> createState() => _EmployeeInOutPresentState();
}

class _EmployeeInOutPresentState extends State<EmployeeInOutPresent> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var todayDate = DateTime.now();
    Provider.of<ReportsProvider>(context, listen: false).reportsFromDate = DateTime(todayDate.year, todayDate.month, 1);
    Provider.of<ReportsProvider>(context, listen: false).reportsToDate = DateTime(todayDate.year, todayDate.month + 1, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.appColor,
        title: const Text('In Out Present',
            style: TextStyle(fontFamily: AppFonts.Medium)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Consumer<ReportsProvider>(
          builder: (BuildContext context, snapshot, Widget? child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                const Center(
                    child: Text(
                  'EMPLOYEE INOUT PRESENT DAYS',
                  style: TextStyle(fontSize: 18, fontFamily: AppFonts.Medium),
                )),
                GestureDetector(
                  onTap: () {
                    snapshot.selectFromDate(context);
                  },
                  child: Container(
                    width: double.infinity,
                    color: Colors.transparent,
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            padding: const EdgeInsets.only(left: 15, bottom: 5),
                            child: const Text('From Date',
                                style: TextStyle(fontFamily: AppFonts.Medium))),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: AppColor.appColor,
                              )),
                          child: Text(
                              DateFormat('dd-MM-yyyy')
                                  .format(snapshot.reportsFromDate),
                              style: const TextStyle(
                                  fontSize: 16, fontFamily: AppFonts.Medium)),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: Colors.transparent,
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          padding: const EdgeInsets.only(left: 15, bottom: 5),
                          child: const Text('To Date',
                              style: TextStyle(fontFamily: AppFonts.Medium))),
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppColor.appColor,
                            )),
                        child: Text(
                            DateFormat('dd-MM-yyyy')
                                .format(DateTime(snapshot.reportsFromDate.year,
                                    snapshot.reportsFromDate.month + 1, 0))
                                .toString(),
                            style: const TextStyle(
                                fontSize: 16, fontFamily: AppFonts.Medium)),
                        // child: Text(DateFormat('dd-MM-yyyy').format(snapshot.reportsToDate),style: const TextStyle(fontSize: 16,fontFamily: AppFonts.Medium)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                StreamBuilder(
                    stream: FirebaseCollection().employeeCollection.doc(FirebaseAuth.instance.currentUser?.email).snapshots(),
                    builder: (context, AsyncSnapshot<DocumentSnapshot<Object?>>currentUserDataSnapshot) {
                      if (currentUserDataSnapshot.hasError) {
                        return const Text("Something went wrong");
                      } else if (!currentUserDataSnapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      } else {

                        Map<String, dynamic> data = currentUserDataSnapshot.data!.data() as Map<String, dynamic>;
                        /*List<String> differenceDateList = [];
                        String differenceDate;

                        for (int i = snapshot.reportsFromDate.day; i <= snapshot.reportsToDate.day; i++) {
                          differenceDate = "${snapshot.reportsFromDate.year}"
                                        "-${snapshot.reportsFromDate.month.toString().length != 1 ? snapshot.reportsFromDate.month :
                                        '0${snapshot.reportsFromDate.month}'}"
                                        "-${i.toString().length == 1 ? '0$i' : i}";

                          differenceDateList.add(differenceDate);
                        }
                        debugPrint('Differance Date List => $differenceDateList');
*/
                        return StreamBuilder(
                            stream: InOutFireAuth().mainCollection.
                            where('currentDate', isGreaterThanOrEqualTo: DateFormat('yyyy-MM-dd')
                                .format(snapshot.reportsFromDate).toString())
                                .where('currentDate', isLessThanOrEqualTo: DateFormat('yyyy-MM-dd')
                                .format(DateTime(snapshot.reportsFromDate.year,
                                snapshot.reportsFromDate.month + 1, 0))
                                .toString())

                            // .where("currentDate", isGreaterThanOrEqualTo:
                            //  DateFormat('dd-MM-yyyy')
                            //      .format(snapshot.reportsFromDate)
                            // ).where("endDate", isGreaterThanOrEqualTo:
                            // DateFormat('dd-MM-yyyy')
                            //     .format(DateTime(snapshot.reportsFromDate.year,
                            //     snapshot.reportsFromDate.month + 1, 0))
                            //     .toString())
                            .snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                    presentSnapshot) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                      style: TextButton.styleFrom(
                                        primary: Colors.white,
                                        backgroundColor:
                                            AppColor.appColor, //// Text Color
                                      ),
                                      onPressed: () async {
                                        print(presentSnapshot.data!.docs.length
                                            .toString());
                                        //Get.to(
                                         /* PdfViewInOutPresent(
                                              DateFormat('dd-MM-yyyy')
                                                  .format(snapshot.reportsFromDate),
                                              DateFormat('dd-MM-yyyy')
                                                  .format(snapshot.reportsToDate),
                                              DateFormat('dd-MM-yyyy')
                                                  .format(DateTime.now()),
                                              data['employeeName'],
                                              data['department'],
                                              data['designation'],
                                              presentSnapshot.data!.docs.length
                                                  .toString()),
                                        );*/
                                        PdfViewInOutPresent().makePdfInOutPresent(DateFormat('dd-MM-yyyy')
                                            .format(snapshot.reportsFromDate),
                                            DateFormat('dd-MM-yyyy')
                                                .format(snapshot.reportsToDate),
                                            DateFormat('dd-MM-yyyy')
                                                .format(DateTime.now()),
                                            data['employeeName'],
                                            data['department'],
                                            data['designation'],
                                            presentSnapshot.data!.docs.length
                                                .toString()).then((value) {
                                                  Get.to(OpenPdfInOutPresent(linked: value));
                                          /*setState((){
                                            Provider.of<ReportsProvider>(context,listen:false).pdf = value;
                                          });*/
                                        });
                                        //);
                                      },
                                      child: const Text('View')),
                                  const SizedBox(
                                    width: 50,
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      style: TextButton.styleFrom(
                                        primary: Colors.white,
                                        backgroundColor:
                                            AppColor.appColor, //// Text Color
                                      ),
                                      child: const Text('Back')),
                                ],
                              );
                            });
                      }
                    })
              ],
            );
      })),
    );
  }
}
