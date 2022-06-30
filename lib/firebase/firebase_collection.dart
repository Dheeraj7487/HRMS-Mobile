import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseCollection {

  final adminCollection = FirebaseFirestore.instance.collection('admin');
  CollectionReference employeeCollection = FirebaseFirestore.instance.collection('employee');
  CollectionReference holidayCollection = FirebaseFirestore.instance.collection('holiday');
  CollectionReference inOutCollection = FirebaseFirestore.instance.collection('employee').
                                        doc(FirebaseAuth.instance.currentUser?.email).collection('InOutTime');

}