import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class TextFieldMixin {
  Widget textFieldWidget(
      {TextEditingController? controller,
      Color? cursorColor,
      TextInputAction? textInputAction,
      InputDecoration? decoration,
      TextInputType? keyboardType,
      Widget? prefixIcon,
      Widget? suffixIcon,
      int? maxLines = 1,
      TextCapitalization textCapitalization = TextCapitalization.none,
      String? Function(String?)? validator,
        String? initialValue,
      bool readOnly = false,
      InputBorder? focusedBorder,
      String? labelText,
      TextStyle? labelStyle}) {
    return Padding(
      padding: const EdgeInsets.only(left: 20,right: 20),
      child: TextFormField(
        cursorColor: AppColor.appBlackColor,
        controller: controller,
        textInputAction: TextInputAction.next,
        initialValue: initialValue,
        readOnly: readOnly,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(0),
          prefixIcon: prefixIcon,
          focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColor.appColor)),
          labelStyle: const TextStyle(
            color: AppColor.appBlackColor,
          ),
          labelText: labelText,
        ),
      ),
    );
  }


  Widget textFieldCardWidget(
      {TextEditingController? controller,
        Color? cursorColor,
        TextInputAction? textInputAction,
        TextInputType? keyboardType,
        String? Function(String?)? validator,
        void Function(String)? onChanged,
        InputDecoration? decoration,
        Widget? prefixIcon,
        Widget? suffixIcon,
        InputBorder? focusedBorder,
        String? labelText,
        bool obscureText = false,
        TextStyle? labelStyle}) {
    return Card(
      child: Container(
        margin: const EdgeInsets.only(top: 5.0),
        child: TextFormField(
          cursorColor: AppColor.appBlackColor,
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(0),
            border: InputBorder.none,
            prefixIcon:prefixIcon,
            suffixIcon: suffixIcon,
            focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColor.appColor)),
            labelText: labelText,
            labelStyle: const TextStyle(
              color: AppColor.appBlackColor,
            ),
          ),
          obscureText: obscureText,
          validator: validator,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
