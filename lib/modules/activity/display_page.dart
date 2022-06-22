import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:sysbin/modules/activity/swap.dart';
import 'package:sysbin/providers/userroleprov.dart';
import 'package:sysbin/services/local_notificationservice.dart';

class ActivityDisplay extends StatelessWidget {
  Map<String, dynamic> data;
  String dbId;
  final bool isComplete;
  final int indexId;
  ActivityDisplay(
      {Key? key,
      required this.data,
      required this.dbId,
      required this.indexId,
      required this.isComplete})
      : super(key: key);

  // Date Difference Checker
  int checkDate() {
    DateTime date2 = DateFormat("yyyy-MM-dd hh:mma")
        .parse('${data['date']} ${data['startTime'].replaceAll(' ', '')}');
    DateTime now = DateTime.now();
    var tomo = DateFormat("yyyy-MM-dd hh:mma").format(now);
    DateTime agAin = DateFormat("yyyy-MM-dd hh:mma").parse(tomo);
    var diffInMins2 = agAin.difference(date2).inSeconds;
    print(diffInMins2);

    if (diffInMins2 < 0) {
      return diffInMins2.abs();
    }

    return 1;
  }

  int randomIndex() {
    Random random = Random();
    int randomNumber = random.nextInt(100) + 1;
    return randomNumber;
  }

  @override
  Widget build(BuildContext context) {
    bool isAdmin = Provider.of<UserRoleProvider>(context, listen: true).isAdmin;

    LocalNotificationSerrvice notiService = LocalNotificationSerrvice();
    notiService.initialize();
    return Scaffold(
      appBar: AppBar(
        title: Text("Detailed Information"),
        actions: [
          if (!isComplete) ...[
            InkWell(
              onTap: () async {
                await notiService.showScheduledNotification(
                    seconds: checkDate(),
                    id: randomIndex(),
                    title: data['eventName'],
                    body: "Event has begun");
                Fluttertoast.showToast(msg: 'Reminder Set');
              },
              child: const Icon(
                Icons.notifications,
                size: 36,
              ),
            ),
          ]
        ],
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Row(
                      children: [
                        Text("Name : ",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'sans-sheriff')),
                        Text(
                          " ${data['eventName']}",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Row(
                      children: [
                        Text(
                          "Date:",
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'sans-sheriff'),
                        ),
                        Text(" ${data['date']}",
                            style: TextStyle(
                                fontSize: 18, fontFamily: 'sans-sheriff')),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Start Time',
                                style: GoogleFonts.lato(
                                  textStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Container(
                                  height: 52,
                                  margin: const EdgeInsets.only(top: 8),
                                  padding: const EdgeInsets.only(left: 14),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          readOnly: true,
                                          autofocus: false,
                                          cursorColor: Colors.black,
                                          validator: (value) {
                                            return null;
                                          },
                                          style: GoogleFonts.lato(
                                            textStyle: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[100],
                                            ),
                                          ),
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              // hintText: _startTime,
                                              hintText: " ${data['startTime']}",
                                              hintStyle: GoogleFonts.lato(
                                                textStyle: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              focusedBorder:
                                                  const UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.white,
                                                          width: 0)),
                                              enabledBorder:
                                                  const UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.white,
                                                          width: 0))),
                                        ),
                                      ),
                                      Container(
                                          child: IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.access_time_outlined,
                                        ),
                                        color: Colors.black,
                                      ))
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'End Time',
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Container(
                                  height: 52,
                                  margin: EdgeInsets.only(top: 8),
                                  padding: EdgeInsets.only(left: 14),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          readOnly: true,
                                          autofocus: false,
                                          cursorColor: Colors.black,
                                          validator: (value) {
                                            return null;
                                          },
                                          style: GoogleFonts.lato(
                                            textStyle: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[100],
                                            ),
                                          ),
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: " ${data['endTime']}",
                                              hintStyle: GoogleFonts.lato(
                                                textStyle: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.white,
                                                          width: 0)),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.white,
                                                          width: 0))),
                                        ),
                                      ),
                                      Container(
                                          child: IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.access_time_outlined,
                                        ),
                                        color: Colors.black,
                                      ))
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Description: ',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'sans-sheriff')),
                  Container(
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: SingleChildScrollView(
                      child: Row(
                        children: [
                          Text(" ${data['desc']}",
                              style: TextStyle(
                                  fontSize: 14, fontFamily: 'sans-sheriff')),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Visibility(
                    visible: isComplete,
                    child: Center(
                      child: ElevatedButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.yellow),
                        onPressed: () {
                          createPDF();
                          print('pressed');
                        },
                        child: const Text(
                          'Get Report',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !isComplete && isAdmin,
                    child: Center(
                      child: ElevatedButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.orange),
                        onPressed: () {
                          SwapData().swapEvents(dbId, data);
                          Fluttertoast.showToast(msg: 'Event Completed');
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Conclude Event',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> createPDF() async {
    PdfDocument document = PdfDocument();
    final page = document.pages.add();
    PdfStringFormat format = PdfStringFormat();

    page.graphics.drawString("${data['eventName']}",
        PdfStandardFont(PdfFontFamily.timesRoman, 30, style: PdfFontStyle.bold),
        format: PdfStringFormat(alignment: PdfTextAlignment.center),
        bounds: const Rect.fromLTWH(270, 0, 0, 0));

    page.graphics.drawString("Start Time : ",
        PdfStandardFont(PdfFontFamily.timesRoman, 15, style: PdfFontStyle.bold),
        bounds: const Rect.fromLTWH(0, 60, 0, 0));
    page.graphics.drawString(
        " ${data['startTime']}", PdfStandardFont(PdfFontFamily.timesRoman, 15),
        bounds: const Rect.fromLTWH(80, 61, 0, 0));

    page.graphics.drawString("End Time : ",
        PdfStandardFont(PdfFontFamily.timesRoman, 15, style: PdfFontStyle.bold),
        bounds: const Rect.fromLTWH(0, 112, 0, 0));
    page.graphics.drawString(
        " ${data['endTime']}", PdfStandardFont(PdfFontFamily.timesRoman, 15),
        bounds: const Rect.fromLTWH(70, 112, 0, 0));

    page.graphics.drawString("Date : ",
        PdfStandardFont(PdfFontFamily.timesRoman, 15, style: PdfFontStyle.bold),
        bounds: const Rect.fromLTWH(0, 160, 0, 0));
    page.graphics.drawString(
        " ${data['date']}", PdfStandardFont(PdfFontFamily.timesRoman, 15),
        bounds: const Rect.fromLTWH(38, 160, 0, 0));

    page.graphics.drawString("Description : ",
        PdfStandardFont(PdfFontFamily.timesRoman, 15, style: PdfFontStyle.bold),
        bounds: const Rect.fromLTWH(0, 210, 0, 0));
    page.graphics.drawString(
        " ${data['desc']}", PdfStandardFont(PdfFontFamily.timesRoman, 15),
        bounds: const Rect.fromLTWH(85, 210, 430, 0),
        format: PdfStringFormat(wordWrap: PdfWordWrapType.word));

    List<int> bytes = document.save();
    document.dispose();

    Future<void> SNLFile() async {
      final directory = await getApplicationDocumentsDirectory();
      final path = directory.path;
      File file = File('$path/Output.pdf');
      await file.writeAsBytes(bytes, flush: true);
      OpenFile.open('$path/Output.pdf');
    }

    SNLFile();
  }
}
