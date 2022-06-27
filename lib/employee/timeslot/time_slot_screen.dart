import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_attendance_app/utils/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TimeSlotScreen extends StatelessWidget {
   TimeSlotScreen({Key? key}) : super(key: key);

   var inOutTimeEmployee = FirebaseFirestore.instance.collection("employee")
       .doc(FirebaseAuth.instance.currentUser!.email).collection('InOutTime').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColor.appColor,
        title: const Text('Entry Exit Time'),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: inOutTimeEmployee,
          builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator());
            }else{
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context,index) {
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return const Center(child: CircularProgressIndicator());
                    }else{
                      return Container(
                        margin: const EdgeInsets.all(10),
                        child:  Card(
                          child: ExpansionTile(
                            textColor: AppColor.appColor,
                            iconColor: AppColor.appColor,
                            controlAffinity: ListTileControlAffinity.leading,
                            childrenPadding:
                            const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            expandedCrossAxisAlignment: CrossAxisAlignment.end,
                            maintainState: true,
                            title: Text('${snapshot.data?.docs[index]['currentDate']}',style: TextStyle(fontSize: 18)),
                            //expandedAlignment: Alignment.topLeft,
                            children: [
                              Row(
                                children: [
                                  Text('In Time'),
                                  Spacer(),
                                  Text('${snapshot.data?.docs[index]['inTime']}'),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('Out Time'),
                                  Spacer(),
                                  Text('${snapshot.data?.docs[index]['outTime']}'),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('Duration'),
                                  Spacer(),
                                  Text('${snapshot.data?.docs[index]['duration']}'),
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
      ),
    );
  }
}
