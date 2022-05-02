import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

  // Function to Build The Grid View based on all the Calcs
  Widget getAllData(var recievedData) {
    if (selectedClass != null) {
      getAllDocs() async {
        var teT = FirebaseFirestore.instance
            .collection('all_attendance_constants')
            .where('subjectClass', isEqualTo: selectedClass)
            .get()
            .then((value) => value);

        return teT;
      }

      return Container(
        child: Text('Hi'),
      );

      return Expanded(
        child: GridView.builder(
            itemCount: 5,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (context, index) {
              return Container(
                  child: Center(
                child: Text(index.toString()),
              ));
            }),
      );
    } else {
      return Text('Select Class');
      // Show Error to Select the Class
    }
  }

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
                              // print(snapshot.data!.docs.length);
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
                              print("MPLength Below ");
                              print(mP.length);

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
                              print(subjectList);
                              for (int i = 0; i < subjectList.length; i++) {
                                for (var doc in mP) {
                                  if (doc['subjectName'] == subjectList[i]) {}
                                }
                              }
                              Map<String, dynamic> getIndividual(int ind) {
                                int totalDaysPresent = 0;
                                int totalDaysAbsent = 0;
                                for (int i = 0; i < mP.length; i++) {
                                  if (mP[i]['colorState'][ind]) {
                                    totalDaysPresent++;
                                  } else {
                                    totalDaysAbsent++;
                                  }
                                }
                                Map<String, dynamic> toJson = {
                                  'totalPresent': totalDaysPresent,
                                  'totalAbsent': totalDaysAbsent,
                                  // 'rollNo': classRange[ind],
                                  'totalClassesTaken': mP.length
                                };
                                return toJson;
                              }

                              return Text('Hola');
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
