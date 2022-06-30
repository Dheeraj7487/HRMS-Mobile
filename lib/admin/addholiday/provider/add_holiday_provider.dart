import 'package:flutter/material.dart';
class AddHolidayProvider extends ChangeNotifier{

  DateTime holidayDate = DateTime.now();
  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: holidayDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != holidayDate) {
        holidayDate = picked;
        notifyListeners();
    }
  }
}