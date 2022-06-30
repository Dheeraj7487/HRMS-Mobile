import 'package:employee_attendance_app/admin/addholiday/auth/add_holiday_fire_auth.dart';
import 'package:employee_attendance_app/mixin/textfield_mixin.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../mixin/button_mixin.dart';
import '../../../utils/app_colors.dart';
import '../provider/add_holiday_provider.dart';

class AddHolidayScreen extends StatefulWidget {
  const AddHolidayScreen({Key? key}) : super(key: key);

  @override
  State<AddHolidayScreen> createState() => _AddHolidayScreenState();
}

class _AddHolidayScreenState extends State<AddHolidayScreen> {

  TextEditingController holidayNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.appColor,
          title: const Text('Add Public Holiday'),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Consumer<AddHolidayProvider>(builder: (_, snapshot, __) {
                    return GestureDetector(
                      onTap : () => snapshot.selectDate(context),
                      child: Container(
                        margin: const EdgeInsets.only(left: 20,right: 20),
                        padding: const EdgeInsets.only(top:10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 12),
                              child: Row(
                                children: [
                                  const Icon(Icons.date_range_outlined,color: AppColor.appColor,),
                                  const SizedBox(width: 10),
                                  Text("${DateFormat('dd-MM-yyyy').format(snapshot.holidayDate)}",style: const TextStyle(fontSize: 16)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10,),
                            const Divider(height: 2,thickness: 2,),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 20),
                  TextFieldMixin().textFieldWidget(
                      controller: holidayNameController,
                      prefixIcon:
                      const Icon(Icons.event, color: AppColor.appColor),
                      labelText: 'Holiday Name',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter holiday name';
                        }
                        return null;
                     },
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                      cursorColor:  AppColor.appColor,
                      maxLines: 6,
                      keyboardType: TextInputType.multiline,
                      minLines: null,
                      controller: descriptionController,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColor.appColor),
                          ),
                          hintText: 'Short description about your event'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Description';
                        }
                        return null;
                      },
                    ),
                  ),

                  const SizedBox(height: 50),
                  Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () async {
                        if(_formKey.currentState!.validate()) {
                          AddHolidayFireAuth().addPublicHoliday(holidayDate: DateFormat('dd-MM-yyyy').format(Provider.of<AddHolidayProvider>(context,listen: false).holidayDate),
                              holidayName: holidayNameController.text,
                              holidayDescription: descriptionController.text);
                          holidayNameController.clear();
                          descriptionController.clear();
                        }
                      },
                      child: ButtonMixin()
                          .stylishButton(onPress: () {}, text: 'Add Holiday'),
                    ),
                  ),
                  const SizedBox(height: 20)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
