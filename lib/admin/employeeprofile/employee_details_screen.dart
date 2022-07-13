import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_attendance_app/admin/employeeprofile/employee_profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../utils/app_colors.dart';

class EmployeeDetailsScreen extends StatelessWidget {
   EmployeeDetailsScreen({Key? key}) : super(key: key);

  var registerEmployeeEmail = FirebaseFirestore.instance.collection("employee").snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.appColor,
        title: const Text('View Details'),
        centerTitle: true,
      ),
      body: StreamBuilder(
          stream: registerEmployeeEmail,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.none ){
              return const Center(child: CircularProgressIndicator());
            } else{
              return ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  shrinkWrap: true,
                  itemBuilder: (context,index) {
                    return GestureDetector(
                      onTap: (){Get.to(ViewAdminEmployeeProfileScreen(email: snapshot.data!.docs[index].id));},
                      child: ListTile(
                        tileColor: index.isOdd ? Colors.blueGrey.shade50 : Colors.white,
                        title: Text('${snapshot.data!.docs[index].id}'),
                        leading: Text('${index+1}'),
                        trailing: Icon(Icons.arrow_forward_ios,size: 12,),
                        // trailing: Icons,
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
