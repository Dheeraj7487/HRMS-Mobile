import 'package:employee_attendance_app/admin/leavestatus/leave_status_screen.dart';
import 'package:employee_attendance_app/employee/leave/auth/leave_fire_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../admin/addholiday/provider/add_holiday_provider.dart';
import '../../firebase/firebase_collection.dart';
import '../../mixin/button_mixin.dart';
import '../../mixin/textfield_mixin.dart';
import '../../utils/app_colors.dart';

class LeaveScreen extends StatefulWidget {
  LeaveScreen({Key? key}) : super(key: key);

  @override
  State<LeaveScreen> createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen> {
  TextEditingController leaveTypeController = TextEditingController();

  TextEditingController reasonController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  DateTime? pickedFrom,pickedTo;
  ScrollController scrollController = ScrollController();

  DateTime leaveFromDate = DateTime.now();
  DateTime leaveToDate = DateTime.now();
  Future<void> selectFromDate(BuildContext context) async {
    pickedFrom = await showDatePicker(
        context: context,
        initialDate: leaveFromDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (pickedFrom != null && pickedFrom != leaveFromDate) {
      leaveFromDate = pickedFrom!;
      setState((){});
    }
  }

  Future<void> selectToDate(BuildContext context) async {
    pickedTo = await showDatePicker(
        context: context,
        initialDate: leaveToDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (pickedTo != null && pickedTo != leaveToDate) {
      leaveToDate = pickedTo!;
      setState((){});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.appColor,
          title: const Text('Apply Leave'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 30),
                GestureDetector(
                    onTap : () => selectFromDate(context),
                    child: Container(
                      width: double.infinity,
                      color: AppColor.whiteColor,
                      margin: const EdgeInsets.only(left: 20,right: 20),
                      padding: const EdgeInsets.only(top:10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 15,bottom: 5),
                              child: const Text('Leave From Date')),
                          Container(
                            margin: const EdgeInsets.only(left: 12),
                            child: Row(
                              children: [
                                const Icon(Icons.date_range_outlined,color: AppColor.appColor,),
                                const SizedBox(width: 10),
                                Text(pickedFrom == null ? "Please select date" : DateFormat('dd-MM-yyyy').format(leaveFromDate),style: const TextStyle(fontSize: 16)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10,),
                          const Divider(height: 1,thickness: 1,color: AppColor.greyColor,),
                        ],
                      ),
                    ),
                  ),


                 GestureDetector(
                    onTap : () {
                     selectToDate(context);
                      },
                    child: Container(
                      width: double.infinity,
                      color: AppColor.whiteColor,
                      margin: const EdgeInsets.only(left: 20,right: 20),
                      padding: const EdgeInsets.only(top:10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              padding: const EdgeInsets.only(left: 15,bottom: 5),
                              child: const Text('Leave To Date')),
                          Container(
                            margin: const EdgeInsets.only(left: 12),
                            child: Row(
                              children: [
                                const Icon(Icons.date_range_outlined,color: AppColor.appColor,),
                                const SizedBox(width: 10),
                                Text(pickedTo == null ? "Please select date" : DateFormat('dd-MM-yyyy').format(leaveToDate),style: const TextStyle(fontSize: 16)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10,),
                          const Divider(height: 1,thickness: 1,color: AppColor.greyColor,),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 5),
                TextFieldMixin().textFieldWidget(
                  controller: leaveTypeController,
                  prefixIcon:
                  const Icon(Icons.event, color: AppColor.appColor),
                  labelText: 'leave Type',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter leave type';
                    }
                    return null;
                  },
                ),

                Container(
                    padding: const EdgeInsets.only(left: 25,bottom: 5,top: 15),
                    child: const Text('Reason')),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Scrollbar(
                    child: Container(
                      child: TextFormField(
                        cursorColor:  AppColor.appColor,
                        scrollController: scrollController,
                       // minLines: 3,
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        controller: reasonController,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColor.appColor),
                            ),),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter reason';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 50),
                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () async {
                      if(_formKey.currentState!.validate()) {
                        LeaveFireAuth().applyLeave(
                            leaveFrom: leaveFromDate.toString().substring(0,10),
                            leaveTo: leaveToDate.toString().substring(0,10),
                            leaveType: leaveTypeController.text,
                            leaveReason: reasonController.text, leaveStatus: 'Applied',
                            leaveEmail: FirebaseAuth.instance.currentUser!.email.toString());
                        leaveTypeController.clear();
                        reasonController.clear();
                      }
                    },
                    child: ButtonMixin()
                        .stylishButton(onPress: () {}, text: 'Apply Leave'),
                  ),
                ),
                const SizedBox(height: 20)
              ],
            ),
          ),
        ),
    );
  }
}
