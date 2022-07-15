import 'package:flutter/material.dart';
class AddHolidayProvider extends ChangeNotifier{

  DateTime holidayDate = DateTime.now();
  DateTime? picked;
  Future<void> selectDate(BuildContext context) async {
    picked = await showDatePicker(
        context: context,
        initialDate: holidayDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != holidayDate) {
        holidayDate = picked!;
        notifyListeners();
    }
  }

  onWillPop(){
    picked = null;
  }

}