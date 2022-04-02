import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sysbin/modules/attendance/Monthly_List/month_detail_page.dart';

class MonthHome extends StatefulWidget {
  final String andId;
  const MonthHome({Key? key, required this.andId}) : super(key: key);

  @override
  State<MonthHome> createState() => _MonthHomeState();
}

class _MonthHomeState extends State<MonthHome> {
  late String andId = widget.andId;

  String? selectedItem;
  // Subject List Here
  late List _subjectList = [];
  String? selectedSubject;
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
  Widget build(BuildContext maincontext) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Expanded(child: Text('View Attendance')),
            InkWell(
              onTap: () {
                setState(() {
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
              .collection(andId)
              .doc('data')
              .collection('class_constants')
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              if (snapshot.data!.docs.isNotEmpty) {
                classNameList() {
                  List<String> temp = [];
                  for (var i = 0; i < snapshot.data!.docs.length; i++) {
                    temp.add(snapshot.data!.docs.elementAt(i).get('className'));
                  }
                  return temp;
                }

                List<String> classNames = classNameList();
                return Column(
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                selectedItem = value;
                              });
                              List<dynamic> fetchedSubjects =
                                  await FirebaseFirestore.instance
                                      .collection(andId)
                                      .doc('data')
                                      .collection('class_constants')
                                      .where('className',
                                          isEqualTo: selectedItem)
                                      .get()
                                      .then((value) => value.docs
                                          .elementAt(0)
                                          .get('subjectList'));
                              List<dynamic> fetchedStudentNumber =
                                  await FirebaseFirestore.instance
                                      .collection(andId)
                                      .doc('data')
                                      .collection('class_constants')
                                      .where('className',
                                          isEqualTo: selectedItem)
                                      .get()
                                      .then((value) => value.docs
                                          .elementAt(0)
                                          .get('classRange'));
                              setState(() {
                                _subjectList = fetchedSubjects;
                                selectedSubject = null;
                                totalStudents =
                                    fetchedStudentNumber.length.toString();
                              });
                            },
                            value: selectedItem,
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
                        const Expanded(
                            child: Text(
                          'Select Subject',
                          style: TextStyle(fontSize: 22),
                        )),
                        Expanded(
                          child: DropdownButton<String>(
                            iconSize: 32,
                            isExpanded: true,
                            onChanged: (value) async {
                              setState(() {
                                selectedSubject = value;
                              });
                            },
                            value: selectedSubject,
                            items: _subjectList
                                .map((item) => DropdownMenuItem(
                                      child: Text(item.toString()),
                                      value: item.toString(),
                                    ))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      totalStudents == null
                          ? 'Total Students : '
                          : 'Total Students : $totalStudents',
                      style: const TextStyle(fontSize: 20),
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
                    StreamBuilder(
                        stream: selectedSubject == null
                            ? FirebaseFirestore.instance
                                .collection('garbage')
                                .snapshots()
                            : FirebaseFirestore.instance
                                .collection(andId)
                                .doc('data')
                                .collection('Attendance')
                                .doc(selectedItem)
                                .collection(selectedSubject!)
                                .snapshots(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                snapshot) {
                          if (snapshot.hasData && snapshot.data != null) {
                            if (snapshot.data!.docs.isNotEmpty) {
                              List classRange =
                                  snapshot.data!.docs[0].data()['classNumbers'];
                              int rangeLength = classRange.length;

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
                                  'rollNo': classRange[ind],
                                  'totalClassesTaken': mP.length
                                };
                                return toJson;
                              }

                              return Expanded(
                                child: ListView.separated(
                                  separatorBuilder: (__, int inde) =>
                                      const SizedBox(
                                    height: 8,
                                  ),
                                  shrinkWrap: true,
                                  itemCount: rangeLength,
                                  itemBuilder: (__, int index) {
                                    Map<String, dynamic> mainDoc =
                                        getIndividual(index);
                                    print(mainDoc);

                                    return ListTile(
                                      leading: const Icon(
                                          Icons.format_list_numbered_outlined),
                                      title: Text(
                                        'Roll No ${classRange[index]}',
                                        style: const TextStyle(
                                          fontSize: 18.5,
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MonthDetailPage(
                                                      recievedData: mainDoc,
                                                    )));
                                      },
                                    );
                                  },
                                ),
                              );
                            } else {
                              return const Center(
                                child: Text('No Attendance to Display'),
                              );
                            }
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        })
                  ],
                );
              } else {
                return const Center(
                  child: Text('No Subjects to Display'),
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
