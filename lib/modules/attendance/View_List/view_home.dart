import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sysbin/modules/attendance/View_List/detail_page.dart';

class ViewHome extends StatefulWidget {
  final String andId;
  const ViewHome({Key? key, required this.andId}) : super(key: key);

  @override
  State<ViewHome> createState() => _ViewHomeState();
}

class _ViewHomeState extends State<ViewHome> {
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
  bool isDescending = true;

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
              width: 20,
            ),
            InkWell(
              onTap: () {
                setState(() {
                  isDescending = !isDescending;
                });
              },
              child: const Icon(
                Icons.compare_arrows,
                size: 36,
              ),
            )
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
                                List<Map<String, dynamic>> sT = [];
                                for (int i = 0; i < mP.length; i++) {
                                  if (mP[i]['month'] == _selectedMonthInt &&
                                      mP[i]['year'].toString() ==
                                          _selectedYear) {
                                    sT.add(mP[i]);
                                  }
                                }
                                mP = sT;
                              } else {
                                mP = sT;
                              }

                              mP.sort((a, b) {
                                var aa = DateTime.parse(a['timeStamp']);
                                var bb = DateTime.parse(b['timeStamp']);
                                return isDescending
                                    ? aa.compareTo(bb)
                                    : bb.compareTo(aa);
                              });

                              return Expanded(
                                child: ListView.separated(
                                  separatorBuilder: (__, int inde) =>
                                      const SizedBox(
                                    height: 8,
                                  ),
                                  shrinkWrap: true,
                                  itemCount: mP.length,
                                  itemBuilder: (__, int index) {
                                    int tempPresent = 0;
                                    int tempAbsent = 0;
                                    // Map<String, dynamic> mainDoc =
                                    //     snapshot.data!.docs[index].data();
                                    Map<String, dynamic> mainDoc = mP[index];

                                    List colorState = mainDoc['colorState'];

                                    for (int i = 0;
                                        i < mainDoc['colorState'].length;
                                        i++) {
                                      if (colorState[i]) {
                                        tempPresent++;
                                      } else {
                                        tempAbsent++;
                                      }
                                    }

                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        color: Colors.grey,
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 104,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Container(
                                                    color: Colors.orange[300],
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(3.0),
                                                          child: Row(
                                                            children: [
                                                              const Expanded(
                                                                  child: Text(
                                                                      'P')),
                                                              const Expanded(
                                                                  child: Text(
                                                                      '|')),
                                                              Expanded(
                                                                  child: Text(
                                                                      tempPresent
                                                                          .toString())),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(3.0),
                                                          child: Row(
                                                            children: [
                                                              const Expanded(
                                                                  child: Text(
                                                                      'A')),
                                                              const Expanded(
                                                                  child: Text(
                                                                      '|')),
                                                              Expanded(
                                                                  child: Text(
                                                                      tempAbsent
                                                                          .toString())),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Column(
                                                  children: [
                                                    Text(mainDoc['takenDate']),
                                                    Text(mainDoc['timeTaken'])
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 60,
                                                child: TextButton(
                                                  onPressed: () async {
                                                    Map<String, dynamic>
                                                        toJson = {
                                                      'colorState':
                                                          mainDoc['colorState'],
                                                      'classRange': mainDoc[
                                                          'classNumbers'],
                                                      'subjectName': mainDoc[
                                                          'subjectName'],
                                                      'timeTaken':
                                                          mainDoc['timeTaken'],
                                                      'takenDate':
                                                          mainDoc['takenDate'],
                                                    };
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                ((context) =>
                                                                    DetailPage(
                                                                      recievedData:
                                                                          toJson,
                                                                    ))));
                                                  },
                                                  child: const Text(
                                                    'View',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15),
                                                  ),
                                                  style: TextButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
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
