import 'dart:io';
import 'dart:typed_data';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

Future<void> createExcel(
    String dropdownValue, String dropdownValue1, var data) async {
  print(data.length);
  final Workbook workbook = Workbook();
  final Worksheet sheet = workbook.worksheets[0];
  sheet.enableSheetCalculations();

  sheet.getRangeByName("A1").setText("Expenditure ");
  sheet.getRangeByName("B1").setText(dropdownValue);
  sheet.getRangeByName("C1").setText(dropdownValue1);
  sheet.getRangeByName("A2").setText("Date");
  sheet.getRangeByName("B2").setText("Name");
  sheet.getRangeByName("C2").setText("Quantity");
  sheet.getRangeByName("D2").setText("Amount Per");
  sheet.getRangeByName("E2").setText("Supplier");
  sheet.getRangeByName("F2").setText("Total");
  for (int i = 0; i < data.length; i++) {
    var rowNumber = (3 + i).toString();
    sheet.getRangeByName("A" + rowNumber).setText(data[i]['date']);
    sheet.getRangeByName("B" + rowNumber).setText(data[i]['name']);
    sheet.getRangeByName("C" + rowNumber).setText(data[i]['quantity']);
    sheet.getRangeByName("D" + rowNumber).setText(data[i]['amount']);
    sheet.getRangeByName("E" + rowNumber).setText(data[i]['supplier']);
    sheet
        .getRangeByName("F" + rowNumber)
        .setFormula('=C$rowNumber*D$rowNumber');
    if (i + 1 == data.length) {
      sheet
          .getRangeByName("F" + ((3 + i) + 1).toString())
          .setFormula('=SUM(F3:F${((3 + i)).toString()})');
    }
  }

  // sheet.getRangeByName("A24").setText("Total");
  final List<int> bytes = workbook.saveAsStream();
  workbook.dispose();

  final String path = (await getApplicationSupportDirectory()).path;
  final String fileName = '$path//Output.xlsx';
  final File file = File(fileName);
  await file.writeAsBytes(bytes, flush: true);
  // final taskId = await FlutterDownloader.enqueue(
  //     url: "data:application/octet-stream;charset=utf-16le;base64,",
  //     savedDir: fileName,
  //     showNotification: true,
  //     openFileFromNotification: true);
  OpenFile.open(fileName);
}
