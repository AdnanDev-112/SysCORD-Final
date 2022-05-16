import 'dart:io';
import 'dart:typed_data';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

// Gen Letters
var aCode = 'A'.codeUnitAt(0);
var zCode = 'Z'.codeUnitAt(0);
List<String> alphabetLetters = List<String>.generate(
  zCode - aCode + 1,
  (index) => String.fromCharCode(aCode + index),
);

Future<void> createTotalExcel(var dataRecieved) async {
  print(dataRecieved);
// Clean the Data
  var _selectedMonth = dataRecieved['Month'];
  var _selectedYear = dataRecieved['Year'];
  var selectedClass = dataRecieved['selectedClass'];
  var subjectsTotal = dataRecieved['attendanceData'];
  var classNumbers = dataRecieved['classRange'];

  // print(subjectsTotal);
  print(dataRecieved);

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
    var rowNumber = (4 + i).toString();
    sheet.getRangeByName("A" + rowNumber).setText(classNumbers[i].toString());
  }
  // Adv
  for (int i = 0; i < subjectsTotal.length; i++) {
    var subjectName = subjectsTotal[i]['className'];
    var classesConducted = subjectsTotal[i]['classesConducted'];
    subjectsTotal[i].remove('className');
    subjectsTotal[i].remove('classesConducted');
    // print(subjectsTotal[i]);
    var attendedDays = [];
    subjectsTotal[i].forEach((key, value) {
      attendedDays.add(value);
    });
    // sheet.getRangeByName("B3").setText(subjectName);
    // sheet.getRangeByName("D3").setText(subjectName);
    // sheet.getRangeByName("B4").setText('Attendance');
    // sheet.getRangeByName("C4").setText('Conducted');
    // *************************************************************************
    var letter1 = alphabetLetters[2 + i * 3 - 1]; // Letter B
    var letter2 = alphabetLetters[3 + i * 3 - 1]; // Letter C
    var letter3 = alphabetLetters[4 + i * 3 - 1]; // Letter D
    // print(letter1);
    // print(letter2);
    // print(letter3);
    sheet.getRangeByName("${letter1}2").setText(subjectName);
    sheet.getRangeByName("${letter3}2").setText('Percentage');
    sheet.getRangeByName("${letter1}3").setText('Attendance');
    sheet.getRangeByName("${letter2}3").setText('Conducted');

    for (int j = 0; j < classNumbers.length; j++) {
      var rowNumber = (4 + j).toString();
      sheet
          .getRangeByName(letter1 + rowNumber)
          .setText(attendedDays[j].toString());
      sheet
          .getRangeByName(letter2 + rowNumber)
          .setText(classesConducted.toString());
      sheet
          .getRangeByName(letter3 + rowNumber)
          .setFormula('=$letter1$rowNumber/$letter2$rowNumber * 100');

      if (j + 1 == classNumbers.length) {
        sheet.getRangeByName(letter3 + ((4 + j) + 1).toString()).setFormula(
            '=((SUM(${letter3 + (4).toString()}:${letter3}${((4 + j)).toString()})/${classNumbers.length}))');
      }

      // Formating
      final ConditionalFormats conditions =
          sheet.getRangeByName(letter3 + rowNumber).conditionalFormats;
      final ConditionalFormat condition = conditions.addCondition();
      final ConditionalFormat condition1 = conditions.addCondition();
      //Represents conditional format rule that the value in target range should be between 10 and 20
      condition.formatType = ExcelCFType.cellValue;
      condition.operator = ExcelComparisonOperator.between;
      condition.firstFormula = '70';
      condition.secondFormula = '100';
      //set back color by hexa decimal.
      condition.backColor = '#30b398';
      // ***************
      condition1.formatType = ExcelCFType.cellValue;
      condition1.operator = ExcelComparisonOperator.less;
      condition1.firstFormula = '70';
      // condition.secondFormula = '100';
      //set back color by hexa decimal.
      condition1.backColor = '#c95349';
    }
  }

  final List<int> bytes = workbook.saveAsStream();
  workbook.dispose();

  final String path = (await getApplicationSupportDirectory()).path;
  final String fileName = '$path//Outputtest.xlsx';
  final File file = File(fileName);
  await file.writeAsBytes(bytes, flush: true);

  OpenFile.open(fileName);
}
