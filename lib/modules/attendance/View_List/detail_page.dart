import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

class DetailPage extends StatelessWidget {
  final Map<String, dynamic> recievedData;
  DetailPage({Key? key, required this.recievedData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List classRange = recievedData['classRange'];
    final List colorState = recievedData['colorState'];
    String subjectName = recievedData['subjectName'];
    String takenDate = recievedData['takenDate'];
    String timeTaken = recievedData['timeTaken'];

    // CSV List
    late List<List<dynamic>> attendanceData;
    // CSV File Creator
    getCsv() async {
      if (await Permission.storage.request().isGranted) {
//store file in documents folder
        try {
          String tmp = await Directory('/storage/emulated/0/SysBIN/downloaded')
              .create(recursive: true)
              .then((Directory drct) => drct.path);
          String dir = tmp + "/$subjectName$takenDate$timeTaken.csv";
          String file = dir;

          File f = File(file);

// Convert rows to String and write as csv file

          String csv = const ListToCsvConverter().convert(attendanceData);
          await f.writeAsString(csv);
          Fluttertoast.showToast(msg: 'File Downloaded');
        } catch (e) {
          print(e);
        }
      } else {
        Map<Permission, PermissionStatus> statuses = await [
          Permission.storage,
        ].request();
      }
    }

    return Scaffold(
      appBar: AppBar(
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Text('Details'),
        GestureDetector(
            onTap: () {
              print(recievedData);
              attendanceData = List<List<dynamic>>.empty(growable: true);
              attendanceData.add([subjectName, takenDate, timeTaken]);
              attendanceData.add(['Roll No', 'Status']);
              print(attendanceData);
              for (int i = 0; i < classRange.length; i++) {
                print(classRange[i]);
//row refer to each column of a row in csv file and rows refer to each row in a file
                List<dynamic> row = List.empty(growable: true);
                row.add("${classRange[i]}");
                row.add(colorState[i] ? "Present" : "Absent");

                attendanceData.add(row);
                print(row);
              }
              getCsv();
            },
            child: const Icon(Icons.download))
      ])),
      body: ListView.builder(
        itemCount: classRange.length,
        shrinkWrap: true,
        itemBuilder: (__, int index) {
          return ListTile(
            leading: const Icon(Icons.format_list_numbered_outlined),
            title: Text(
              'Roll No ${classRange[index]}',
              style: TextStyle(
                  fontSize: 18.5,
                  color: colorState[index] ? Colors.green : Colors.red),
            ),
            trailing: Icon(colorState[index] ? Icons.check : Icons.clear),
            subtitle: Text(colorState[index] ? 'Present' : 'Absent'),
          );
        },
      ),
    );
  }
}
