import 'dart:io';
import 'dart:typed_data';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

Future<void> createTotalExcel(var dataRecieved) async {
// Clean the Data
  var _selectedMonth = dataRecieved['Month'];
  var _selectedYear = dataRecieved['Year'];
  var selectedClass = dataRecieved['selectedClass'];
  var subjectsTotal = dataRecieved['attendanceData'];
  var classNumbers = dataRecieved['classRange'];

  print(subjectsTotal);

  //
  final Workbook workbook = Workbook();
  final Worksheet sheet = workbook.worksheets[0];
  sheet.enableSheetCalculations();

// First Intro Line
  // sheet.getRangeByName("A1").setText("Total ");
  sheet.getRangeByName("A2").setText("Roll Numbers ");
  sheet.getRangeByName("B1").setText('Attendance');
  sheet.getRangeByName("C1").setText(selectedClass);
  sheet.getRangeByName("D1").setText(_selectedMonth);
  sheet.getRangeByName("E1").setText(_selectedYear);
  // ****************************
  // Set Init
  for (int i = 0; i < classNumbers.length; i++) {
    var rowNumber = (3 + i).toString();
    sheet.getRangeByName("A" + rowNumber).setText(classNumbers[i].toString());
  }
  // Adv
  for (int i = 0; i < subjectsTotal.length; i++) {
    var subjectName = subjectsTotal[i]['className'];
    var classesConducted = subjectsTotal[i]['classesConducted'];
  }

  final List<int> bytes = workbook.saveAsStream();
  workbook.dispose();

  final String path = (await getApplicationSupportDirectory()).path;
  final String fileName = '$path//Outputtest.xlsx';
  final File file = File(fileName);
  await file.writeAsBytes(bytes, flush: true);

  OpenFile.open(fileName);
}
