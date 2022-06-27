import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class ViewRegisteredEmployee extends StatelessWidget {
  ViewRegisteredEmployee({Key? key}) : super(key: key);

  var registerEmployeeEmail =
  FirebaseFirestore.instance
      .collection("employee")
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.appColor,
        title: const Text('View Registered Employee'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: registerEmployeeEmail,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.none ){
              return const Center(child: CircularProgressIndicator());
            } else{
              return ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context,index) {
                    return ListTile(
                      tileColor: index.isOdd ? AppColor.backgroundColor : Colors.white,
                      leading: Text('${index+1}'),
                      title: Text('${snapshot.data!.docs[index].id}'),
                    );
                  }
              );
            }
          }
        ),
      )
    );
  }
}
