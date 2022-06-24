import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';

Widget DashboardDetailsWidget(String imageUrl,String title,String description){
  return Card(
    elevation: 5,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    shadowColor: AppColor.blackColor,
    color: AppColor.listingBgColor,
    child:  Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColor.darkGreyColor)
            ),
            child: IntrinsicHeight(child: ClipOval(child: Image.network(imageUrl,height: 80,width: 100,fit: BoxFit.contain))),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,style: TextStyle(fontSize: 18),textAlign: TextAlign.start),
              SizedBox(height: 10),
              Text(description,style: TextStyle(color:AppColor.darkGreyColor,fontSize: 14),textAlign: TextAlign.start),
            ],
          ),
        ),
        const Expanded(
            flex: 2,
            child: Icon(Icons.arrow_forward_ios,color: AppColor.darkGreyColor,))
      ],
    ),
  );

}