import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';

class ViewEmployeeinOutScreen extends StatefulWidget {
  ViewEmployeeinOutScreen({Key? key,required this.email}) : super(key: key);

  String email;

  @override
  State<ViewEmployeeinOutScreen> createState() => _ViewEmployeeinOutScreenState();
}

class _ViewEmployeeinOutScreenState extends State<ViewEmployeeinOutScreen> {

  @override
  Widget build(BuildContext context) {
    var inOutTimeEmployee = FirebaseFirestore.instance.collection("employee")
        .doc('${widget.email}').collection('InOutTime').snapshots();

    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.appColor,
          title: const Text('Employee In Out',style: const TextStyle(fontFamily: AppFonts.CormorantGaramondSemiBold)),
          centerTitle: true,
        ),
      body: StreamBuilder(
          stream: inOutTimeEmployee,
          builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator());
            }else if (snapshot.hasError) {
              return const Center(child: Text("Something went wrong",style: TextStyle(fontFamily: AppFonts.CormorantGaramondSemiBold)));
            }
            else if (!snapshot.hasData) {
              return const Center(child: Text("No Data Found",style: TextStyle(fontFamily: AppFonts.CormorantGaramondSemiBold)));
            } else if (snapshot.requireData.docChanges.isEmpty){
              return const Center(child: Text("No Data Found",style: TextStyle(fontFamily: AppFonts.CormorantGaramondSemiBold)));
            } else{
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  shrinkWrap: true,
                  itemBuilder: (context,index) {
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return const Center(child: CircularProgressIndicator());
                    }else{
                      return Container(
                        alignment: Alignment.topLeft,
                        margin: const EdgeInsets.only(left: 10,right: 10),
                        child:  Card(
                          child: ExpansionTile(
                            textColor: AppColor.appColor,
                            iconColor: AppColor.appColor,
                            controlAffinity: ListTileControlAffinity.leading,
                            childrenPadding:
                            const EdgeInsets.symmetric(vertical: 2, horizontal: 50),
                            expandedCrossAxisAlignment: CrossAxisAlignment.end,
                            maintainState: true,
                            title: Text('${snapshot.data?.docs[index]['currentDate']}',style: const TextStyle(fontFamily: AppFonts.CormorantGaramondSemiBold,fontSize: 18)),
                            //expandedAlignment: Alignment.topLeft,
                            children: [
                              Row(
                                children: [
                                  const Text('In Time',style: TextStyle(fontFamily: AppFonts.CormorantGaramondSemiBold)),
                                  const Spacer(),
                                  Text('${snapshot.data?.docs[index]['inTime']}',style: const TextStyle(fontFamily: AppFonts.CormorantGaramondSemiBold)),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text('Out Time',style: TextStyle(fontFamily: AppFonts.CormorantGaramondSemiBold)),
                                  const Spacer(),
                                  Text('${snapshot.data?.docs[index]['outTime']}',style: const TextStyle(fontFamily: AppFonts.CormorantGaramondSemiBold)),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text('Duration',style: TextStyle(fontFamily: AppFonts.CormorantGaramondSemiBold)),
                                  const Spacer(),
                                  Text('${snapshot.data?.docs[index]['duration']}',style: const TextStyle(fontFamily: AppFonts.CormorantGaramondSemiBold)),
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
      )
    );
  }
}
