
import 'package:employee_attendance_app/employee/reports/openpdf/download_pdf_file.dart';
import 'package:employee_attendance_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class OpenPdfInOutSummary extends StatefulWidget {

  var linked;

  OpenPdfInOutSummary({Key? key,required this.linked}) : super(key: key);

  @override
  State<OpenPdfInOutSummary> createState() => _OpenPdfInOutSummaryState();
}

class _OpenPdfInOutSummaryState extends State<OpenPdfInOutSummary> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.linked == null ? const Center(child: CircularProgressIndicator(strokeWidth: 4,color: Colors.indigo,),) :
      SfPdfViewer.memory(widget.linked),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.appColor,
        onPressed: (){
          DownloadPdfFile().downloadFile(widget.linked);
        },
        child: const Icon(Icons.download),
      ),
    );
  }
}
