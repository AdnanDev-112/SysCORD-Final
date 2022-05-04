import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sysbin/modules/attendance/Total_all_subjects/excSheet.dart';

class TotalPage extends StatefulWidget {
  final String andId;
  const TotalPage({Key? key, required this.andId}) : super(key: key);

  @override
  State<TotalPage> createState() => _TotalPageState();
}

class _TotalPageState extends State<TotalPage> {
  final attendanceRef =
      FirebaseFirestore.instance.collection('all_attendance_constants');
  late String andId = widget.andId;

  // Subject List Here
  String? selectedClass;
  String? totalStudents;

  // Date Fixer
  List monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  List years = [2022, 2023, 2024, 2025, 2026];
  String? _selectedMonth;
  String? _selectedYear;
  int? _selectedMonthInt;
  int? _selectedYearInt;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Expanded(child: Text('Total Attendance')),
            InkWell(
              onTap: () {
                setState(() {
                  selectedClass = null;
                  _selectedMonth = null;
                  _selectedYear = null;
                  _selectedMonthInt = null;
                  _selectedYearInt = null;
                });
              },
              child: const Icon(
                Icons.refresh,
                size: 36,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('all_attendance_constants')
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              if (snapshot.data!.docs.isNotEmpty) {
                var insideData = snapshot.data!.docs;
                // print(snapshot.data!.docs.length);
                classNameList() {
                  List<String> temp = [];

                  for (var doc in snapshot.data!.docs) {
                    temp.add(doc['subjectClass']);
                  }
                  var tT = temp.toSet().toList();
                  temp = tT;
                  return temp;
                }

                List<String> classNames = classNameList();
                return Column(
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Select Class',
                            style: TextStyle(fontSize: 22),
                          ),
                        ),
                        Expanded(
                          child: DropdownButton<String>(
                            iconSize: 32,
                            isExpanded: true,
                            onChanged: (value) async {
                              setState(() {
                                selectedClass = value;
                              });

                              // setState(() {
                              //   selectedClass = null;
                              // });
                            },
                            value: selectedClass,
                            items:
                                // item1s
                                classNames
                                    .map((item) => DropdownMenuItem(
                                          child: Text(item),
                                          value: item,
                                        ))
                                    .toList(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButton(
                            hint: const Text('Month'),
                            isExpanded: true,
                            items: monthNames
                                .map((item) => DropdownMenuItem(
                                      child: Text(item),
                                      value: item,
                                    ))
                                .toList(),
                            value: _selectedMonth,
                            onChanged: (value) {
                              setState(() {
                                _selectedMonth = value.toString();
                                _selectedMonthInt =
                                    monthNames.indexOf(_selectedMonth) + 1;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: DropdownButton(
                            isExpanded: true,
                            hint: const Text('Year'),
                            value: _selectedYear,
                            items: years
                                .map((item) => DropdownMenuItem(
                                      child: Text(item.toString()),
                                      value: item.toString(),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedYear = value.toString();
                                _selectedYearInt =
                                    years.indexOf(_selectedYear) + 1;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    // getAllData(insideData),
                    StreamBuilder(
                        stream: selectedClass != null
                            ? FirebaseFirestore.instance
                                .collection('all_attendance_constants')
                                .where('subjectClass', isEqualTo: selectedClass)
                                .snapshots()
                            : FirebaseFirestore.instance
                                .collection('Garbage')
                                .snapshots(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                snapshot) {
                          if (snapshot.hasData && snapshot.data != null) {
                            if (snapshot.data!.docs.isNotEmpty) {
                              List<Map<String, dynamic>> mP = [];
                              List<Map<String, dynamic>> sT = [];
                              for (int i = 0;
                                  i < snapshot.data!.docs.length;
                                  i++) {
                                mP.add(snapshot.data!.docs[i].data());
                                sT.add(snapshot.data!.docs[i].data());
                              }
                              if (_selectedMonthInt != null &&
                                  _selectedYearInt != null) {
                                List<Map<String, dynamic>> tT = [];
                                for (int i = 0; i < mP.length; i++) {
                                  if (mP[i]['month'] == _selectedMonthInt &&
                                      mP[i]['year'].toString() ==
                                          _selectedYear) {
                                    tT.add(mP[i]);
                                  }
                                }
                                mP = tT;
                              } else {
                                mP = sT;
                              }
                              // print("MPLength Below ");
                              // print(mP.length);
// Subject List From Set To List so we have all the available Subjects
                              subjectNameList() {
                                List<String> temp = [];

                                for (var doc in mP) {
                                  temp.add(doc['subjectName']);
                                }
                                var tT = temp.toSet().toList();
                                temp = tT;
                                return temp;
                              }

                              List<String> subjectList = subjectNameList();
                              // ******************************
                              // print(subjectList);
                              // Individual Subject Data
                              for (int i = 0; i < subjectList.length; i++) {
                                List<dynamic> individualDoc = [];
                                for (var doc in mP) {
                                  if (doc['subjectName'] == subjectList[i]) {
                                    individualDoc.add(doc);
                                  }
                                }
                                List<Map<String, dynamic>> indiData = [];
                                for (int i = 0; i < individualDoc.length; i++) {
                                  Map<String, dynamic> docDataMap = Map();
                                  var classLength =
                                      individualDoc[0]['classNumbers'].length;

                                  for (int j = 0; j < classLength; j++) {
                                    if (individualDoc[i]['colorState'][j]) {
                                      docDataMap[individualDoc[i]
                                              ['classNumbers'][j]
                                          .toString()] = 1;

                                      // totalDaysPresent++;
                                    } else {
                                      // totalDaysAbsent++;
                                      docDataMap[individualDoc[i]
                                              ['classNumbers'][j]
                                          .toString()] = 0;
                                    }
                                  }
                                  // print(docDataMap);
                                  indiData.add(docDataMap);
                                }
                                if (indiData.length > 1) {
                                  var tempArray = [];
                                  indiData[0].forEach((key, value) {
                                    tempArray.add(value);
                                  });

                                  for (int i = 1; i < indiData.length; i++) {
                                    var tempArray1 = [];
                                    // if (i != indiData.length - 1) {
                                    indiData[i].forEach((key, value) {
                                      tempArray1.add(value);
                                    });
                                    // }

                                    for (int i = 0; i < tempArray.length; i++) {
                                      tempArray[i] += tempArray1[i];
                                    }
                                  }
                                }
                                print(indiData);
                              }

                              if (_selectedMonth != null &&
                                  _selectedYear != null) {
                                return ElevatedButton(
                                    style: TextButton.styleFrom(
                                        backgroundColor: Colors.yellow),
                                    onPressed: () {
                                      createTotalExcel();
                                    },
                                    child: Text(
                                      'Get Sheet',
                                      style: TextStyle(color: Colors.black),
                                    ));
                              } else {
                                return Center(
                                  child: Text('Select Month and Year'),
                                );
                              }
                            } else {
                              return const Center(
                                child: Text('No Data to Display'),
                              );
                            }
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        })

                    // ********************************************
                  ],
                );
              } else {
                return const Center(
                  child: Text('No Data to Display'),
                );
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
