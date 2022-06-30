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
            }else if (snapshot.hasError) {
              return const Text("Something went wrong");
            }
            else if (!snapshot.hasData) {
              return const Text("Document does not exist");
            } else if (snapshot.requireData.docChanges.isEmpty){
              return const Text("Data does not exist");
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
                            const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            expandedCrossAxisAlignment: CrossAxisAlignment.end,
                            maintainState: true,
                            title: Text('${snapshot.data?.docs[index]['currentDate']}',style: const TextStyle(fontSize: 18)),
                            //expandedAlignment: Alignment.topLeft,
                            children: [
                              Row(
                                children: [
                                  const Text('In Time'),
                                  const Spacer(),
                                  Text('${snapshot.data?.docs[index]['inTime']}'),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text('Out Time'),
                                  const Spacer(),
                                  Text('${snapshot.data?.docs[index]['outTime']}'),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text('Duration'),
                                  const Spacer(),
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
