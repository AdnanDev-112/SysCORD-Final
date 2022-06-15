import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class ActivityDisplay extends StatelessWidget {
  Map data;
  final bool isComplete;
  ActivityDisplay({Key? key, required this.data, required this.isComplete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detailed Information"),
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
                        Text("Date:",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'sans-sheriff')),
                        Text(" ${data['date']}",
                            style: TextStyle(
                                fontSize: 18, fontFamily: 'sans-sheriff')),
                      ],
                    ),
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
                  Visibility(
                    visible: isComplete,
                    child: ElevatedButton(
                      style:
                          TextButton.styleFrom(backgroundColor: Colors.yellow),
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
