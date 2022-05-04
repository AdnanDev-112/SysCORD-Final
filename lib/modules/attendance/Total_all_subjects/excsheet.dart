import 'dart:io';
import 'dart:typed_data';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

Future<void> createTotalExcel() async {
  final Workbook workbook = Workbook();
  final Worksheet sheet = workbook.worksheets[0];
  sheet.enableSheetCalculations();

  sheet.getRangeByName("A1").setText("Expenditure ");
  sheet.getRangeByName("B1").setText('Test');

  // sheet.getRangeByName("A24").setText("Total");
  final List<int> bytes = workbook.saveAsStream();
  workbook.dispose();

  final String path = (await getApplicationSupportDirectory()).path;
  final String fileName = '$path//Outputtest.xlsx';
  final File file = File(fileName);
  await file.writeAsBytes(bytes, flush: true);
  // final taskId = await FlutterDownloader.enqueue(
  //     url: "data:application/octet-stream;charset=utf-16le;base64,",
  //     savedDir: fileName,
  //     showNotification: true,
  //     openFileFromNotification: true);
  OpenFile.open(fileName);
}
