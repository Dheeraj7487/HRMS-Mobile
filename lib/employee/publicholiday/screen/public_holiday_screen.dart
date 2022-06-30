import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../utils/app_colors.dart';

class PublicHolidayScreen extends StatelessWidget {
  PublicHolidayScreen({Key? key}) : super(key: key);

  var pubilcHolidayDetails =
  FirebaseFirestore.instance
      .collection("holiday")
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.appColor,
        title: const Text('Public Holiday'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
          child: StreamBuilder(
            stream: pubilcHolidayDetails,
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> streamSnapshot)  {
                if(streamSnapshot.connectionState == ConnectionState.waiting){
                  return const Center(child: CircularProgressIndicator());
                } if (streamSnapshot.hasError) {
                  return const Text("Something went wrong");
                } else if (streamSnapshot.connectionState == ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator(),);
                } else if (streamSnapshot.requireData.docChanges.isEmpty){
                  return const Text("Data does not exist");
                } else{
                  return ListView.builder(
                      itemCount: streamSnapshot.data!.docs.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context,index) {
                        return Card(
                          color: AppColor.backgroundColor,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  title: Text('${streamSnapshot.data?.docs[index]['holidayDate']}'),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 5),
                                      Text('${streamSnapshot.data?.docs[index]['holidayName']}',style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                                      const Divider(height: 15,thickness: 2,),
                                      Text('${streamSnapshot.data?.docs[index]['holidayDescription']}'),
                                      const SizedBox(height: 5),
                                    ],
                                  ),
                                ),


                                /*Text('Date'),
                          SizedBox(height: 10),
                          Text('Event Name'),
                          SizedBox(height: 10),*/
                              ],
                            ),
                          ),
                        );
                      }
                  );
                }
            }
          ),
        )
      ),
    );
  }
}
