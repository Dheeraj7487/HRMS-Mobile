import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_attendance_app/utils/app_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

class LeaveStatusApplied extends StatelessWidget {
  const LeaveStatusApplied({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.appColor,
        title: const Text('Leave Status',style: TextStyle(fontFamily: AppFonts.CormorantGaramondSemiBold)),
        centerTitle: true,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('leave').where('leaveEmail',isEqualTo: FirebaseAuth.instance.currentUser?.email).snapshots(),
          builder: (context,AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator());
            }else if (snapshot.hasError) {
              return const Center(child: Text("Something went wrong",style: TextStyle(fontFamily: AppFonts.CormorantGaramondSemiBold)));
            }
            else if (!snapshot.hasData) {
              return const Center(child: Text("No Data Found",style: TextStyle(fontFamily: AppFonts.CormorantGaramondSemiBold)));
            } else if (snapshot.requireData.docChanges.isEmpty){
              return const Center(child: Text("No Data Found",style: TextStyle(fontFamily: AppFonts.CormorantGaramondSemiBold)));
            }  else{
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  shrinkWrap: true,
                  itemBuilder: (context,index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 10.0,right: 10),
                      child: Card(
                        color: snapshot.data?.docs[index]['leaveType'] == 'Flexi Leave' ? AppColor.whiteColor : AppColor.backgroundColor,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0,right: 10,top: 10,bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Visibility(
                                visible: snapshot.data?.docs[index]['leaveType'] == 'Flexi Leave',
                                  child: Text('${snapshot.data?.docs[index]['leaveForm']}',
                                    style: const TextStyle(fontSize: 16,fontFamily: AppFonts.CormorantGaramondSemiBold),)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${snapshot.data?.docs[index]['leaveType'] == 'Flexi Leave' ?
                                  snapshot.data?.docs[index]['leaveFromTime'] : snapshot.data?.docs[index]['leaveForm']}',
                                      style: const TextStyle(fontFamily: AppFonts.CormorantGaramondSemiBold)),
                                  Text('${snapshot.data?.docs[index]['leaveType'] == 'Flexi Leave' ?
                                  snapshot.data?.docs[index]['leaveToTime'] : snapshot.data?.docs[index]['leaveTo']}',
                                      style: const TextStyle(fontFamily: AppFonts.CormorantGaramondSemiBold)),
                                  /*Text('${snapshot.data?.docs[index]['leaveType'] == 'Flexi Leave' ?
                                  snapshot.data?.docs[index]['leaveHours'] : snapshot.data?.docs[index]['leaveDays']}'),*/
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('${snapshot.data?.docs[index]['leaveType']}',style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w400,overflow: TextOverflow.ellipsis,fontFamily: AppFonts.CormorantGaramondBold),maxLines: 1,),
                                        Text('${snapshot.data?.docs[index]['leaveReason']}',style: const TextStyle(fontSize: 12,overflow: TextOverflow.ellipsis,fontFamily: AppFonts.CormorantGaramondMedium),maxLines: 2),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                        padding: const EdgeInsets.all(10),
                                        width: 100,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: snapshot.data?.docs[index]['leaveStatus'] == 'Pending' ?
                                          AppColor.darkGreyColor : snapshot.data?.docs[index]['leaveStatus'] == 'Approved' ?
                                          AppColor.appColor : AppColor.redColor,
                                        ),
                                        child: Center(child: Text('${snapshot.data?.docs[index]['leaveStatus']}',style: const TextStyle(color: AppColor.whiteColor,fontFamily: AppFonts.CormorantGaramondBold)))),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
              );
            }
          }
      ),
    );
  }
}
