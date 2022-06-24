import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

class ViewRegisteredEmployee extends StatelessWidget {
  ViewRegisteredEmployee({Key? key}) : super(key: key);

  CollectionReference _collectionRef =
  FirebaseFirestore.instance.collection('collection');
  Future<void> getData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef.get();
    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    print(allData);
  }

  /*Future getDocs() async {
    QuerySnapshot querySnapshot = await Firestore.instance.collection("collection").getDocuments();
    for (int i = 0; i < querySnapshot.documents.length; i++) {
      var a = querySnapshot.documents[i];
      print(a.documentID);
    }
  }
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.appColor,
        title: const Text('Registered Employee'),
        centerTitle: true,
      ),
      body:  FutureBuilder(
        //future: Firestore.instance.collection("expenses").snapshots,
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Object?>> snapshot) {
          return ListView.builder(
            // itemCount: ,
              itemBuilder: (context,index){
                return Text("data");
              }
          );
        }
      )
    );
  }
}
