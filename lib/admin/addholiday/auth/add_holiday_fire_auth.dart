
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../firebase/firebase_collection.dart';

class AddHolidayFireAuth{

  Future<void> addPublicHoliday(
      {required String holidayDate,
        required String holidayName,
        required String holidayDescription,
      }) async {
    DocumentReference documentReferencer =
    FirebaseCollection().holidayCollection.doc(holidayDate);

    Map<String, dynamic> data = <String, dynamic>{
      "holidayDate": holidayDate.toString(),
      "holidayName": holidayName.toString(),
      "holidayDescription": holidayDescription.toString()
    };
    print('Holiday data=> $data');

    FirebaseCollection().holidayCollection.get().then((querySnapshot) {
      for (var result in querySnapshot.docs) {
        print(result.data());
      }
    });
    await documentReferencer
        .set(data)
        .whenComplete(() => Get.snackbar('Holiday', 'Added Public Holiday'))
        .catchError((e) => Get.snackbar('Error', e));
  }

}