import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../firebase/firebase_collection.dart';

class LeaveFireAuth{

  Future<void> applyLeave(
      {
        required String leaveEmail,
        required String leaveFrom,
        required String leaveTo,
        required String leaveType,
        required String leaveReason,
        required String leaveStatus}) async {
    DocumentReference documentReferencer =
    FirebaseFirestore.instance.collection('leave').doc('$leaveEmail $leaveFrom');

    Map<String, dynamic> data = <String, dynamic>{
      "leaveEmail": leaveEmail.toString(),
      "leaveForm": leaveFrom.toString(),
      "leaveTo": leaveTo.toString(),
      "leaveStatus": leaveStatus.toString(),
      "leaveReason": leaveReason.toString(),
      "leaveType": leaveType.toString(),
    };
    print('Leave Application Data => $data');

    await documentReferencer
        .set(data)
        .whenComplete(() => print("Applying for leave"))
        .catchError((e) => print(e));
  }

}