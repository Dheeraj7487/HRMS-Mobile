import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:employee_attendance_app/employee/leave/provider/leave_provider.dart';
import 'package:employee_attendance_app/employee/timeslot/provider/attendance_details_provider.dart';
import 'package:employee_attendance_app/utils/app_colors.dart';
import 'package:employee_attendance_app/utils/app_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AttendanceDetailsScreen extends StatefulWidget {
  const AttendanceDetailsScreen({Key? key}) : super(key: key);

  @override
  State<AttendanceDetailsScreen> createState() => _AttendanceDetailsScreenState();
}

class _AttendanceDetailsScreenState extends State<AttendanceDetailsScreen> {
 /*  var inOutTimeEmployee = FirebaseFirestore.instance.collection("employee")
       .doc(FirebaseAuth.instance.currentUser!.email).collection('InOutTime').snapshots();
*/
  var inOutTimeEmployee;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: Provider.of<AttendanceDetailsProvider>(context,listen: false).onWillPop(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColor.appColor,
          title: const Text('Attendance Details',style: TextStyle(fontFamily: AppFonts.CormorantGaramondSemiBold),),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20,),
              Container(
                width: double.infinity,
                color: Colors.transparent,
                margin: const EdgeInsets.only(right: 20),
                padding: const EdgeInsets.only(left: 25),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                          child: const Text('Month',style: TextStyle(fontFamily: AppFonts.CormorantGaramondSemiBold),)),
                    ),

                    Expanded(
                      flex: 1,
                      child: DropdownButtonFormField2(
                        decoration: InputDecoration(
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                         ),
                        value: Provider.of<AttendanceDetailsProvider>(context,listen: false).selectMonth,
                        isExpanded: true,
                        isDense: true,
                        selectedItemHighlightColor: AppColor.backgroundColor,
                        dropdownMaxHeight: 200,
                        buttonPadding: const EdgeInsets.only(left: 14, right: 14),
                        buttonHeight: 15,
                        style: const TextStyle(color: AppColor.appBlackColor, fontSize: 14,fontFamily: AppFonts.CormorantGaramondMedium),
                        iconOnClick: const Icon(Icons.arrow_drop_up),
                        icon: const Icon(Icons.arrow_drop_down),
                        scrollbarRadius: const Radius.circular(40),
                        scrollbarThickness: 3,
                        scrollbarAlwaysShow: true,
                        dropdownDecoration: BoxDecoration(borderRadius: BorderRadius.circular(10),),
                        buttonDecoration: BoxDecoration(borderRadius: BorderRadius.circular(10),),
                        onChanged: (String? newValue) {
                          Provider.of<AttendanceDetailsProvider>(context,listen: false).selectMonth = newValue!;
                          Provider.of<AttendanceDetailsProvider>(context,listen: false).getMonth;
                        },
                        items: Provider.of<AttendanceDetailsProvider>(context,listen: false).monthItem
                            .map<DropdownMenuItem<String>>((String leaveName) {
                          return DropdownMenuItem<String>(
                              value: leaveName,
                              child: Text(leaveName)
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              Container(
                width: double.infinity,
                color: Colors.transparent,
                margin: const EdgeInsets.only(right: 20),
                padding: const EdgeInsets.only(left: 25),
                child: Row(
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Text('Year',style: TextStyle(fontFamily: AppFonts.CormorantGaramondSemiBold)),
                    ),

                    Expanded(
                      flex: 1,
                      child: DropdownButtonFormField2(
                        decoration: InputDecoration(
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        value: Provider.of<AttendanceDetailsProvider>(context,listen: false).selectYear,
                        isExpanded: true,
                        dropdownMaxHeight: 200,
                        selectedItemHighlightColor: AppColor.backgroundColor,
                        isDense: true,
                        buttonPadding: const EdgeInsets.only(left: 14, right: 14),
                        buttonHeight: 15,
                        style: const TextStyle(color: AppColor.appBlackColor, fontSize: 14,fontFamily: AppFonts.CormorantGaramondMedium),
                        iconOnClick: const Icon(Icons.arrow_drop_up),
                        icon: const Icon(Icons.arrow_drop_down),
                        scrollbarRadius: const Radius.circular(40),
                        scrollbarThickness: 3,
                        scrollbarAlwaysShow: true,
                        dropdownDecoration: BoxDecoration(borderRadius: BorderRadius.circular(10),),
                        buttonDecoration: BoxDecoration(borderRadius: BorderRadius.circular(10),),
                        onChanged: (String? newValue) {
                          Provider.of<AttendanceDetailsProvider>(context,listen: false).selectYear = newValue!;
                          Provider.of<AttendanceDetailsProvider>(context,listen: false).getYear;
                        },
                        items: Provider.of<AttendanceDetailsProvider>(context,listen: false).yearItem
                            .map<DropdownMenuItem<String>>((String leaveName) {
                          return DropdownMenuItem<String>(
                              value: leaveName,
                              child: Text(leaveName)
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      margin: const EdgeInsets.only(right: 20),
                      padding: const EdgeInsets.only(left: 25),
                      child: const Text('Search Panel',style: TextStyle(fontSize: 18,fontFamily: AppFonts.CormorantGaramondSemiBold),)),
                  Container(
                      margin: const EdgeInsets.only(right: 20),
                      child: TextButton(onPressed: (){
                        setState((){
                          print(DateFormat.yMMMM().format(DateTime.now()));
                          print(Provider.of<AttendanceDetailsProvider>(context,listen: false).selectMonth);
                          print(Provider.of<AttendanceDetailsProvider>(context,listen: false).selectYear);
                          print('${Provider.of<AttendanceDetailsProvider>(context,listen: false).selectMonth} ${Provider.of<AttendanceDetailsProvider>(context,listen: false).selectYear}');
                          inOutTimeEmployee = FirebaseFirestore.instance.collection("employee")
                              .doc(FirebaseAuth.instance.currentUser!.email).collection('InOutTime').
                          where('yearMonth',isEqualTo: '${Provider.of<AttendanceDetailsProvider>(context,listen: false).selectMonth} ${Provider.of<AttendanceDetailsProvider>(context,listen: false).selectYear}').snapshots();
                        });
                      }, child: const Text('Go',style: TextStyle(fontFamily: AppFonts.CormorantGaramondSemiBold),))),
                ],
              ),
              const SizedBox(height: 10,),
              const Divider(height: 1,thickness: 1,),
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection("employee")
                    .doc(FirebaseAuth.instance.currentUser!.email).collection('InOutTime').
                where('yearMonth',isEqualTo: '${Provider.of<AttendanceDetailsProvider>(context,listen: false).selectMonth} ${Provider.of<AttendanceDetailsProvider>(context,listen: false).selectYear}').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return const Center(child: CircularProgressIndicator());
                  }else if (snapshot.hasError) {
                    return const Center(child: Text("Something went wrong",style: TextStyle(fontFamily: AppFonts.CormorantGaramondSemiBold),));
                  }
                  else if (!snapshot.hasData) {
                    return const Center(child: Text("No Data Found",style: TextStyle(fontFamily: AppFonts.CormorantGaramondSemiBold),));
                  } else if (snapshot.requireData.docChanges.isEmpty){
                    return const Center(child: Text("No Data Found",style: TextStyle(fontFamily: AppFonts.CormorantGaramondSemiBold),));
                  } else{
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context,index) {
                          if(snapshot.connectionState == ConnectionState.waiting){
                            return const Center(child: CircularProgressIndicator());
                          }else{
                            return Container(
                              margin: const EdgeInsets.only(left: 10,right: 10),
                              child:  Card(
                                child: ExpansionTile(
                                  textColor: AppColor.appColor,
                                  iconColor: AppColor.appColor,
                                  controlAffinity: ListTileControlAffinity.leading,
                                  childrenPadding:
                                  const EdgeInsets.symmetric(vertical: 5, horizontal: 50),
                                  expandedCrossAxisAlignment: CrossAxisAlignment.end,
                                  maintainState: true,
                                  title: Text('${snapshot.data?.docs[index]['currentDate']}',style: const TextStyle(fontSize: 18,fontFamily: AppFonts.CormorantGaramondSemiBold)),
                                  children: [
                                    Row(
                                      children: [
                                        const Text('In Time',style: TextStyle(fontFamily: AppFonts.CormorantGaramondSemiBold),),
                                        const Spacer(),
                                        Text('${snapshot.data?.docs[index]['inTime']}',style: TextStyle(fontFamily: AppFonts.CormorantGaramondSemiBold)),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text('Out Time',style: TextStyle(fontFamily: AppFonts.CormorantGaramondSemiBold)),
                                        const Spacer(),
                                        Text('${snapshot.data?.docs[index]['outTime']}',style: TextStyle(fontFamily: AppFonts.CormorantGaramondSemiBold)),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text('Duration',style: TextStyle(fontFamily: AppFonts.CormorantGaramondSemiBold)),
                                        const Spacer(),
                                        Text('${snapshot.data?.docs[index]['duration']}',style: TextStyle(fontFamily: AppFonts.CormorantGaramondSemiBold)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        }
                    );
                  }
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
