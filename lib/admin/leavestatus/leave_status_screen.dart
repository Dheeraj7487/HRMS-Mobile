import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../employee/leave/auth/leave_fire_auth.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_fonts.dart';

class LeaveStatusScreen extends StatelessWidget {
  const LeaveStatusScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.appColor,
        title: const Text('Leave Status',style: TextStyle(fontFamily: AppFonts.Medium)),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('leave').snapshots(),
        builder: (context,AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }else if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong",style: TextStyle(fontFamily: AppFonts.Medium)));
          }
          else if (!snapshot.hasData) {
            return const Center(child: Text("No Data Found",style: TextStyle(fontFamily: AppFonts.Medium)));
          } else if (snapshot.requireData.docChanges.isEmpty){
            return const Center(child: Text("No Data Found",style: TextStyle(fontFamily: AppFonts.Medium)));
          } else{
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                itemBuilder: (context,index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 10.0,right: 10,top: 10),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0,right: 10,top: 5,bottom: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${snapshot.data?.docs[index]['leaveEmail']}',style: const TextStyle(color: AppColor.appColor,fontSize: 16,fontFamily: AppFonts.Medium)),
                            const SizedBox(height: 5),
                            Visibility(
                                visible: snapshot.data?.docs[index]['leaveType'] == 'Flexi Leave',
                                child: Text('${snapshot.data?.docs[index]['leaveForm']}',style: const TextStyle(fontFamily: AppFonts.Medium))),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${snapshot.data?.docs[index]['leaveType'] == 'Flexi Leave' ?
                                snapshot.data?.docs[index]['leaveFromTime'] : snapshot.data?.docs[index]['leaveForm']}',
                                    style: const TextStyle(fontFamily: AppFonts.Medium)),
                                Text('${snapshot.data?.docs[index]['leaveType'] == 'Flexi Leave' ?
                                snapshot.data?.docs[index]['leaveToTime'] : snapshot.data?.docs[index]['leaveTo']}',
                                    style: const TextStyle(fontFamily: AppFonts.Medium)),
                                Text('${snapshot.data?.docs[index]['leaveType'] == 'Flexi Leave' ?
                                snapshot.data?.docs[index]['leaveHours'] : snapshot.data?.docs[index]['leaveDays']}',
                                    style: const TextStyle(fontFamily: AppFonts.Medium)),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('${snapshot.data?.docs[index]['leaveType']}',style: const TextStyle(fontSize: 18,overflow: TextOverflow.ellipsis,fontFamily: AppFonts.Medium),maxLines: 1,),
                                      Text('${snapshot.data?.docs[index]['leaveReason']}',style: const TextStyle(fontSize: 12,overflow: TextOverflow.ellipsis,fontFamily: AppFonts.Medium),maxLines: 2,),
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
                                      child: Center(child: Text('${snapshot.data?.docs[index]['leaveStatus']}',style: const TextStyle(color: AppColor.whiteColor,fontFamily: AppFonts.Medium)))),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed: (){
                                    LeaveFireAuth().applyLeave(
                                        leaveFrom: snapshot.data?.docs[index]['leaveForm'],
                                        leaveTo: snapshot.data?.docs[index]['leaveTo'],
                                        leaveDays: snapshot.data?.docs[index]['leaveDays'],
                                        leaveType: snapshot.data?.docs[index]['leaveType'],
                                        leaveReason: snapshot.data?.docs[index]['leaveReason'],
                                        leaveStatus: 'Approved',
                                        leaveEmail: snapshot.data?.docs[index]['leaveEmail'],
                                        leaveFromTime: snapshot.data?.docs[index]['leaveFromTime'],
                                        leaveHours: snapshot.data?.docs[index]['leaveHours'],
                                        leaveToTime: snapshot.data?.docs[index]['leaveToTime']
                                    );
                                  },
                                  child: const Text('Approved',style: TextStyle(color: AppColor.appColor,fontFamily: AppFonts.Medium),),
                                ),
                                const SizedBox(width: 20),
                                TextButton(
                                  onPressed: (){
                                    LeaveFireAuth().applyLeave(
                                        leaveFrom: snapshot.data?.docs[index]['leaveForm'],
                                        leaveTo: snapshot.data?.docs[index]['leaveTo'],
                                        leaveDays: snapshot.data?.docs[index]['leaveDays'],
                                        leaveType: snapshot.data?.docs[index]['leaveType'],
                                        leaveReason: snapshot.data?.docs[index]['leaveReason'],
                                        leaveStatus: 'Rejected',
                                        leaveEmail: snapshot.data?.docs[index]['leaveEmail'],
                                        leaveFromTime: snapshot.data?.docs[index]['leaveFromTime'],
                                        leaveHours: snapshot.data?.docs[index]['leaveHours'],
                                        leaveToTime: snapshot.data?.docs[index]['leaveToTime']
                                    );
                                  },
                                  child: const Text('Rejected',style: TextStyle(color: AppColor.appColor,fontFamily: AppFonts.Medium)),
                                )
                              ],
                            )
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
