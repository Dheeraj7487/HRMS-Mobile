import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:employee_attendance_app/utils/app_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadPdfFile{


  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      PermissionStatus result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  Future<bool> savePdf(url, fileName) async {
    Directory? directory;
    var linked;
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          directory = await getExternalStorageDirectory();
          String newPath = "";
          List<String> paths = directory!.path.split("/");
          for (int x = 1; x < paths.length; x++) {
            String folder = paths[x];
            if (folder != "Android") {
              newPath += "/" + folder;
            } else {
              break;
            }
          }
          newPath = newPath + "/HRMS Reports";
          directory = Directory(newPath);

          if (!await directory.exists()) {
            await directory.create(recursive: true);
          }
          if (await directory.exists()) {
            String tempPath = directory.path;
            final filePath = tempPath + '/${fileName}.pdf';
            ByteData bytes = ByteData.view(url.buffer);
            final buffer = bytes.buffer;
            File(filePath).writeAsBytes(buffer.asUint8List(url.offsetInBytes, url.lengthInBytes));
            return true;
          }
          return false;
        } else {
          return false;
        }
      }
      else if(Platform.isIOS) {
        if (await _requestPermission(Permission.storage)) {
          directory = await getApplicationDocumentsDirectory();
          if (!await directory.exists()) {
            await directory.create(recursive: true);
          }
          if (await directory.exists()) {
            File saveFile = File(directory.path + '/${fileName}.pdf');
            //await saveFile.writeAsBytes(linked);
            await saveFile.writeAsBytes(url);
            return true;
          }
          return false;
        } else {
          return false;
        }
      }
      else{
        return false;
      }
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  downloadFile(linked) async {
    Random random = Random();

    bool downloaded = await savePdf(linked,'report${random.nextInt(10)}');
    if (downloaded) {
      AppUtils.instance.showToast(toastMessage: 'File Downloaded');
      debugPrint("File Downloaded");
    } else {
      AppUtils.instance.showToast(toastMessage: 'File Failed');
      debugPrint("Problem Downloading File");
    }
  }
}