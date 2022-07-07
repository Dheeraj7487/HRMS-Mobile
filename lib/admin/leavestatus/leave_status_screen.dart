import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../employee/leave/auth/leave_fire_auth.dart';
import '../../utils/app_colors.dart';

class LeaveStatusScreen extends StatelessWidget {
  const LeaveStatusScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.appColor,
        title: const Text('Leave Status'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('leave').snapshots(),
        builder: (context,AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }else if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }
          else if (!snapshot.hasData) {
            return const Center(child: Text("Document does not exist"));
          } else if (snapshot.requireData.docChanges.isEmpty){
            return const Center(child: Text("Data is empty"));
          } else{
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                itemBuilder: (context,index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 10.0,right: 10,top: 10,bottom: 10),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0,right: 10,top: 10,bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${snapshot.data?.docs[index]['leaveEmail']}',style: TextStyle(color: AppColor.appColor,fontSize: 16),),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${snapshot.data?.docs[index]['leaveForm']}',),
                                Text('${snapshot.data?.docs[index]['leaveTo']}'),
                              ],
                            ),
                            const SizedBox(height: 10,),
                             Text('${snapshot.data?.docs[index]['leaveType']}',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                             Text('${snapshot.data?.docs[index]['leaveReason']}',style: TextStyle(fontSize: 12),),
                             SizedBox(height: 20),
                             Container(
                                 padding: EdgeInsets.all(10),
                                 width: 100,
                                 decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(10),
                                   color: snapshot.data?.docs[index]['leaveStatus'] == 'Applied' ?
                                   AppColor.darkGreyColor : snapshot.data?.docs[index]['leaveStatus'] == 'Approved' ?
                                   AppColor.appColor : AppColor.redColor,
                                 ),
                                 child: Center(child: Text('${snapshot.data?.docs[index]['leaveStatus']}',style: TextStyle(color: AppColor.whiteColor)))),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed: (){
                                    LeaveFireAuth().applyLeave(
                                        leaveFrom: snapshot.data?.docs[index]['leaveForm'],
                                        leaveTo: snapshot.data?.docs[index]['leaveTo'],
                                        leaveType: snapshot.data?.docs[index]['leaveType'],
                                        leaveReason: snapshot.data?.docs[index]['leaveReason'],
                                        leaveStatus: 'Approved',
                                        leaveEmail: snapshot.data?.docs[index]['leaveEmail']);
                                  },
                                  child: const Text('Approved',style: TextStyle(color: AppColor.appColor),),
                                ),
                                const SizedBox(width: 20),
                                TextButton(
                                  onPressed: (){
                                    LeaveFireAuth().applyLeave(
                                        leaveFrom: snapshot.data?.docs[index]['leaveForm'],
                                        leaveTo: snapshot.data?.docs[index]['leaveTo'],
                                        leaveType: snapshot.data?.docs[index]['leaveType'],
                                        leaveReason: snapshot.data?.docs[index]['leaveReason'],
                                        leaveStatus: 'Rejected',
                                        leaveEmail: snapshot.data?.docs[index]['leaveEmail']);
                                  },
                                  child: const Text('Rejected',style: TextStyle(color: AppColor.appColor)),
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
