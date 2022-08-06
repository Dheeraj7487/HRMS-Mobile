import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:employee_attendance_app/employee/leave/auth/leave_fire_auth.dart';
import 'package:employee_attendance_app/employee/leave/provider/leave_provider.dart';
import 'package:employee_attendance_app/firebase/firebase_collection.dart';
import 'package:employee_attendance_app/utils/app_fonts.dart';
import 'package:employee_attendance_app/utils/app_images.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:time_range/time_range.dart';
import '../../mixin/button_mixin.dart';
import '../../utils/app_colors.dart';
import '../../widget/employee_bottom_navigationbar.dart';

class LeaveScreen extends StatefulWidget {
  LeaveScreen({Key? key}) : super(key: key);

  @override
  State<LeaveScreen> createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen> {
  TextEditingController leaveTypeController = TextEditingController();

  TextEditingController hourController = TextEditingController();
  //TextEditingController toHourController = TextEditingController();
  TextEditingController reasonController = TextEditingController();
  TextEditingController daysController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  ScrollController scrollController = ScrollController();
  DateTime? pickedFrom,pickedTo;
  TextEditingController leaveFromDate = TextEditingController();
  TimeOfDay? pickedTime;
  bool fromDateValidation = false;
  bool toDateValidation = false;

  Future<void> selectFromDate(BuildContext context) async {
    pickedFrom = await showDatePicker(
        context: context,
        initialDate: Provider.of<LeaveProvider>(context,listen: false).leaveFromDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    //notifyListeners();
    if (pickedFrom != null && pickedFrom != Provider.of<LeaveProvider>(context,listen: false).leaveFromDate) {
      Provider.of<LeaveProvider>(context, listen: false).leaveFromDate = pickedFrom!;
      Provider.of<LeaveProvider>(context, listen: false).countValueGet();
      if(Provider.of<LeaveProvider>(context, listen: false).countLeave <0){
        pickedTo = null;
      }
    }
  }

  Future<void> selectToDate(BuildContext context) async {
    pickedTo = await showDatePicker(
        context: context,
        initialDate: Provider.of<LeaveProvider>(context,listen: false).leaveFromDate,
        firstDate: pickedFrom ?? DateTime.now(),
        lastDate: DateTime(2101),
    );
    if (pickedTo != null && pickedTo != Provider.of<LeaveProvider>(context,listen: false).leaveToDate) {
      Provider.of<LeaveProvider>(context,listen: false).leaveToDate = pickedTo!;
      Provider.of<LeaveProvider>(context,listen: false).countValueGet();
    }
  }

  /*Future<void> selectFromDate(BuildContext context) async {
    pickedFrom = await showDatePicker(
        context: context,
        initialDate: Provider.of<LeaveProvider>(context,listen: false).leaveFromDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    //notifyListeners();
    if (pickedFrom != null && pickedFrom != Provider.of<LeaveProvider>(context,listen: false).leaveFromDate) {

      Provider.of<LeaveProvider>(context, listen: false).leaveFromDate = pickedFrom!;
      setState(() async{
        pickedTo = await showDatePicker(
          context: context,
          initialDate: Provider.of<LeaveProvider>(context,listen: false).leaveFromDate,
          firstDate: DateTime.now(),
          lastDate: DateTime(2101),
        );
        if (pickedTo != null && pickedTo != Provider.of<LeaveProvider>(context,listen: false).leaveToDate) {
          Provider.of<LeaveProvider>(context,listen: false).leaveToDate = pickedTo!;
          Provider.of<LeaveProvider>(context,listen: false).countValueGet();
        }
      });

      *//*Provider.of<LeaveProvider>(context, listen: false).countValueGet();
      if(Provider.of<LeaveProvider>(context, listen: false).countLeave <0){
        pickedTo = null;
      }*//*
    }
  }*/

 /* Future<void> selectFromTime(BuildContext context) async {
    pickedTime = await showTimePicker(
        context: context,
        initialEntryMode: TimePickerEntryMode.input,
        initialTime: Provider.of<LeaveProvider>(context,listen: false).selectedTime,
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: const ColorScheme.light().copyWith(
                primary: AppColor.greyColorLight,
              ),
            ), child: MediaQuery(
              data:
              MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: child!,
            ),
          );
        }
    );

    if (pickedTime != null && pickedTime != Provider.of<LeaveProvider>(context,listen: false).selectedTime ) {
        Provider.of<LeaveProvider>(context,listen: false).selectedTime = pickedTime!;
        setState((){});
    }
  }*/

  @override
  void initState() {
    // TODO: implement initState
    Provider.of<LeaveProvider>(context,listen: false).onWillPop(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
        appBar: AppBar(
          title: const Text('Apply Leave'),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: StreamBuilder(
              stream: FirebaseCollection().employeeCollection.doc(FirebaseAuth.instance.currentUser?.email).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Object?>> snapshot) {
                if (!snapshot.hasData || !snapshot.data!.exists || snapshot.hasError) {
                  return const Center(child: CircularProgressIndicator());
                }
                else if(snapshot.requireData.exists){
                  Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                  return Consumer<LeaveProvider>(
                    builder: (BuildContext context, snapshot, Widget? child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(height: 30),
                          Container(
                            width: double.infinity,
                            color: Colors.transparent,
                            margin: const EdgeInsets.only(left: 20, right: 20),
                            child: DropdownButtonFormField2(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              value: snapshot.selectLeaveType,
                              validator: (value) {
                                if (value == null) {
                                  return 'Leave type is required';
                                }
                              },
                              hint: const Text('Select Leave Type',style: TextStyle(fontFamily: AppFonts.Medium)),
                              isExpanded: true,
                              isDense: true,
                              buttonPadding: const EdgeInsets.only(left: 14, right: 14),
                              buttonHeight: 20,
                              style: const TextStyle(color: AppColor.appBlackColor, fontSize: 14,fontFamily: AppFonts.Medium),
                              iconOnClick: const Icon(Icons.arrow_drop_up),
                              icon: const Icon(Icons.arrow_drop_down),
                              scrollbarRadius: const Radius.circular(40),
                              scrollbarThickness: 3,
                              scrollbarAlwaysShow: true,
                              dropdownDecoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                              buttonDecoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                              onChanged: (String? newValue) {
                                snapshot.selectLeaveType = newValue!;
                                snapshot.getLeaveType;
                                if (snapshot.selectLeaveType == 'Flexi Leave') {
                                  pickedTo = null;
                                  pickedFrom = null;
                                  reasonController.clear();
                                  setState(() {});
                                }
                                if (snapshot.selectLeaveType != 'Flexi Leave') {
                                  pickedTime = null;
                                  hourController.clear();
                                  snapshot.countHour = 0;
                                  //toHourController.clear();
                                  reasonController.clear();
                                  setState(() {});
                                }
                              },
                              items: snapshot.selectLeaveTypeItem
                                  .map<DropdownMenuItem<String>>((String leaveName) {
                                return DropdownMenuItem<String>(
                                    value: leaveName,
                                    child: Row(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(right: 10),
                                          child: Image.asset(AppImage.leaveIcon,height: 20,width: 20,),),
                                        Text(leaveName)
                                      ],
                                    )
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                              padding: const EdgeInsets.only(left: 25,bottom: 5),
                              child: const Text('Leave From Date',style: TextStyle(fontFamily: AppFonts.Medium))),
                          GestureDetector(
                            onTap : () {
                              selectFromDate(context);
                              // pickedTo = null;
                              print(snapshot.countLeave);
                            },
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(color: fromDateValidation== true ? AppColor.redColor : AppColor.darkGreyColor),
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              margin: const EdgeInsets.only(left: 20,right: 20),
                              padding: const EdgeInsets.only(top:15,bottom: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(left: 12),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.date_range_outlined,color: AppColor.appColor),
                                        const SizedBox(width: 10),
                                        Text(pickedFrom == null ? "Please select date" : DateFormat('dd-MM-yyyy').format(snapshot.leaveFromDate),style: const TextStyle(fontSize: 16,fontFamily: AppFonts.Medium)),
                                      ],
                                    ),
                                  ),
                                  // const SizedBox(height: 10),
                                  //   const Divider(height: 1,thickness: 1,color: AppColor.greyColor),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 4,),
                          Visibility(
                              visible: fromDateValidation== false ? false : true,
                              child: const Padding(
                                padding: EdgeInsets.only(left: 30),
                                child: Text('Please choose date',style: TextStyle(fontSize: 12,color: AppColor.redColor),),
                              )),
                          const SizedBox(height: 10,),
                          Container(
                              padding: const EdgeInsets.only(left: 25,bottom: 5),
                              child: const Text('Leave To Date',style: TextStyle(fontFamily: AppFonts.Medium))),
                          GestureDetector(
                            onTap : () {
                              selectToDate(context);
                              snapshot.getFromLeave();
                              print(snapshot.countLeave);
                              print(pickedFrom);
                              print(snapshot.leaveFromDate);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(color: fromDateValidation== true ? AppColor.redColor : AppColor.darkGreyColor),
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              margin: const EdgeInsets.only(left: 20,right: 20),
                              padding: const EdgeInsets.only(top:15,bottom: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(left: 12),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.date_range_outlined,color: AppColor.appColor,),
                                        const SizedBox(width: 10),
                                        Text(pickedTo == null ? "Please select date" : DateFormat('dd-MM-yyyy').format(snapshot.leaveToDate),style: const TextStyle(fontSize: 16,fontFamily: AppFonts.Medium)),
                                      ],
                                    ),
                                  ),
                                  /* Text('No. of days ${
                                    pickedTo == null ? '0' :
                                pickedFrom==null || pickedTo==null ?
                                snapshot.countLeave : snapshot.countLeave+1}',style: TextStyle(fontSize: 10),),*/
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 4,),
                          Visibility(
                              visible: toDateValidation== false ? false : true,
                              child: const Padding(
                                  padding: EdgeInsets.only(left: 30),
                                  child:  Text('Please choose date',style: TextStyle(fontSize: 12,color: AppColor.redColor),))),

                          Visibility(
                            visible: snapshot.selectLeaveType != 'Flexi Leave' ? true : false,
                            child: const Padding(
                              padding: EdgeInsets.only(left: 25,bottom: 5,top: 10),
                              child: Text('No of days',style: TextStyle(fontFamily: AppFonts.Medium)),
                            ),),
                          Visibility(
                            visible: snapshot.selectLeaveType != 'Flexi Leave' ? true : false,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20, right: 20),
                              child: TextFormField(
                                cursorColor:  AppColor.appColor,
                                keyboardType: TextInputType.number,
                                controller: daysController..text =
                                    '${pickedTo == null ? '0' : pickedFrom==null || pickedTo==null ? snapshot.countLeave : snapshot.countLeave+1}',
                                readOnly: true,
                                style: const TextStyle(fontFamily: AppFonts.Medium),
                                textInputAction: TextInputAction.done,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: AppColor.appColor),
                                  ),),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter hours';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),

                          /*Visibility(
                          visible: snapshot.selectLeaveType == 'Flexi Leave' ? true : false,
                          child: GestureDetector(
                            onTap : () {
                              selectFromTime(context);
                            },
                            child: Container(
                              width: double.infinity,
                              color: Colors.transparent,
                              margin: const EdgeInsets.only(left: 20,right: 20),
                              padding: const EdgeInsets.only(top:10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      padding: const EdgeInsets.only(left: 15,bottom: 5),
                                      child: const Text('From Time')),
                                  Container(
                                    margin: const EdgeInsets.only(left: 12),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.timer_sharp,color: AppColor.appColor,),
                                        const SizedBox(width: 10),
                                        Text('${pickedTime == null ? "Select Time" : pickedTime.toString().substring(10,15)}',style: const TextStyle(fontSize: 16)),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10,),
                                  const Divider(height: 1,thickness: 1,color: AppColor.greyColor,),
                                ],
                              ),
                            ),
                          ),
                        ),

                        Visibility(
                          visible: snapshot.selectLeaveType == 'Flexi Leave' ? true : false,
                          child: const Padding(
                              padding: EdgeInsets.only(left: 25,bottom: 5,top: 10),
                              child: Text('No of hours')),
                        ),
                        Visibility(
                          visible: snapshot.selectLeaveType == 'Flexi Leave' ? true : false,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: TextFormField(
                              cursorColor:  AppColor.appColor,
                              keyboardType: TextInputType.number,
                              controller: hourController,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: AppColor.appColor),
                                ),),
                              onChanged: (value){
                                toHourController..text
                                = value == '' ||
                                    value == null
                                    ? '--/--' : pickedTime == null ? '' : '${pickedTime!.hour+int.parse(hourController.text)}${pickedTime.toString().substring(12,15)}';
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter hours';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),

                        Visibility(
                          visible: snapshot.selectLeaveType == 'Flexi Leave' ? true : false,
                          child: const Padding(
                              padding: EdgeInsets.only(left: 25,bottom: 5,top: 10),
                              child: Text('To hours')),
                        ),
                        Visibility(
                          visible: snapshot.selectLeaveType == 'Flexi Leave' ? true : false,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: TextFormField(
                              cursorColor:  AppColor.appColor,
                              keyboardType: TextInputType.number,
                              controller: toHourController..text
                                  = hourController.text.toString() == '' ||
                                      hourController.text.toString() == null
                              ? '--/--' : pickedTime == null ? '--/--' : '${pickedTime!.hour+int.parse(hourController.text)}${pickedTime.toString().substring(12,15)}',
                              //controller: toHourController..text = '${pickedTime == null && toHourController.text == null ? "--/--" : '${int.parse(pickedTime)+int.parse(hourController.text)}'}',
                              readOnly: true,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: AppColor.appColor),
                                ),),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter hours';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),*/

                          Visibility(
                            visible: snapshot.selectLeaveType == 'Flexi Leave' ? true : false,
                            child: TimeRange(
                              fromTitle: const Text('From Time',style: TextStyle(fontFamily: AppFonts.Medium)),
                              toTitle: const Text('To Time',style: TextStyle(fontFamily: AppFonts.Medium)),
                              titlePadding: 20,
                              activeTextStyle: const TextStyle(color: Colors.white,fontFamily: AppFonts.Medium),
                              backgroundColor: Colors.transparent,
                              borderColor: AppColor.appColor,
                              activeBorderColor: AppColor.appColor,
                              textStyle:const TextStyle(fontFamily: AppFonts.Medium),
                              activeBackgroundColor: AppColor.appColor,
                              firstTime: const TimeOfDay(hour: 09, minute: 30),
                              lastTime: const TimeOfDay(hour: 19, minute: 00),
                              timeStep: 30,
                              timeBlock: 60,
                              onRangeCompleted: (range) {
                                setState((){
                                  print(range?.start);
                                  print(range?.end);
                                  print(range!.end.hour-range.start.hour);
                                  snapshot.countHour = range.end.hour-range.start.hour;
                                  snapshot.fromTime = range.start.toString();
                                  snapshot.toTime = range.end.toString();
                                });
                              },
                            ),
                          ),

                          Visibility(
                            visible: snapshot.selectLeaveType == 'Flexi Leave' ? true : false,
                            child: const Padding(
                                padding: EdgeInsets.only(left: 25,bottom: 5,top: 10),
                                child: Text('No of hours',style: TextStyle(fontFamily: AppFonts.Medium))),
                          ),
                          Visibility(
                            visible: snapshot.selectLeaveType == 'Flexi Leave' ? true : false,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20, right: 20),
                              child: TextFormField(
                                cursorColor:  AppColor.appColor,
                                keyboardType: TextInputType.number,
                                readOnly: true,
                                style: const TextStyle(fontFamily: AppFonts.Medium),
                                controller: hourController..text = snapshot.countHour.toString(),
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: AppColor.appColor),
                                  ),),
                                onChanged: (value){
                                  /*toHourController..text
                                = value == '' ||
                                    value == null
                                    ? '--/--' : pickedTime == null ? '' : '${pickedTime!.hour+int.parse(hourController.text)}${pickedTime.toString().substring(12,15)}';*/
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter hours';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),

                          Container(
                              padding: const EdgeInsets.only(left: 25,bottom: 5,top: 10),
                              child: const Text('Reason',style: TextStyle(fontFamily: AppFonts.Medium))),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Scrollbar(
                              child: TextFormField(
                                cursorColor:  AppColor.appColor,
                                scrollController: scrollController,
                                // minLines: 3,
                                maxLines: 3,
                                style: const TextStyle(fontFamily: AppFonts.Medium),
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

                          const SizedBox(height: 50),
                          Align(
                            alignment: Alignment.center,
                            child: GestureDetector(
                              onTap: () async {
                                setState((){
                                  fromDateValidation = true;
                                  toDateValidation = true;
                                });
                                if(pickedFrom !=null){
                                  setState((){
                                    fromDateValidation = false;
                                  });
                                }
                                if(pickedTo !=null){
                                  setState((){
                                    toDateValidation = false;
                                  });
                                }
                                if(_formKey.currentState!.validate() && pickedTo!=null && pickedFrom!=null) {
                                  LeaveFireAuth().applyLeave(
                                      leaveFrom: snapshot.leaveFromDate.toString().substring(0,10),
                                      leaveTo: snapshot.selectLeaveType == 'Flexi Leave' ? '' : snapshot.leaveToDate.toString().substring(0,10),
                                      leaveDays: snapshot.selectLeaveType == 'Flexi Leave' ? '' : daysController.text.toString(),
                                      leaveType: snapshot.selectLeaveType!,
                                      leaveReason: reasonController.text,
                                      leaveStatus: 'Pending',
                                      leaveEmail: FirebaseAuth.instance.currentUser!.email.toString(),
                                      leaveFromTime: snapshot.selectLeaveType == 'Flexi Leave' ? snapshot.fromTime.toString().substring(10,15) : '' ,
                                      leaveToTime: snapshot.selectLeaveType == 'Flexi Leave' ? snapshot.toTime.toString().substring(10,15) :'' ,
                                      leaveHours: snapshot.selectLeaveType == 'Flexi Leave' ? hourController.text : '',
                                      leaveEmployeeName: '${data['employeeName']?.toString().capitalizeFirst}');
                                  leaveTypeController.clear();
                                  reasonController.clear();
                                  Get.to(BottomNavBarScreen());
                                }
                              },
                              child: ButtonMixin()
                                  .stylishButton(onPress: () {}, text: 'Apply Leave'),
                            ),
                          ),
                          const SizedBox(height: 20)
                        ],
                      );
                    },
                  );
                }else if (snapshot.connectionState == ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator(),);
                }
                else{
                  return const Center(child: CircularProgressIndicator(),);
                }
              }
            ),
          ),
        ),
    );
  }
}
