import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sysbin/models/attendance/take_model.dart';
import 'package:unique_identifier/unique_identifier.dart';

class TakeAttendance extends StatefulWidget {
  final String andId;
  const TakeAttendance({Key? key, required this.andId}) : super(key: key);

  @override
  State<TakeAttendance> createState() => _TakeAttendanceState();
}

class _TakeAttendanceState extends State<TakeAttendance> {
  late String andId = widget.andId;
// Variables
  String? selectedItem;
  List classRange = [];
  // Subject List Here
  late List _subjectList = [];
  String? selectedSubject;
  late List<bool> colorState;

//
//// Random Strign Generator
  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890@#%^&*()!';
  final Random _rnd = Random();
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  @override
  Widget build(BuildContext context) {
// Date Format
    DateTime _date = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    //Todays Date
    late String formattedDate = formatter.format(_date);

    // The Time
    String formattedTime = DateFormat('hh:mm a').format(DateTime.now());
    String tempTime = DateFormat('hh:mm').format(DateTime.now());
    String timeStamp = '$formattedDate $tempTime';
    // Adding the Attendance in DB
    Future saveAttendance(List classRange, String className, List colorSt,
        String selectSub) async {
      final dbDoc = FirebaseFirestore.instance
          .collection('Users')
          .doc('devices')
          .collection(andId)
          .doc('data')
          .collection('Attendance')
          .doc(className)
          .collection(selectSub)
          .doc('$formattedDate $formattedTime ${getRandomString(2)}');

      // Class Initialized
      final classDoc = SavedAttendance(
        classNumbers: classRange,
        subjectName: selectedSubject,
        subjectClass: selectedItem,
        colorState: colorState,
        timeTaken: formattedTime,
        takenDate: formattedDate,
        timeStamp: timeStamp,
        month: DateTime.now().month,
        yearTaken: DateTime.now().year,
      );

      final json = classDoc.toJson();
      await dbDoc.set(json);

// *********************************************************************************
      // Adding into all_attendance_constant
      final classConst = FirebaseFirestore.instance
          .collection('all_attendance_constants')
          // .doc(className)
          // .collection(selectSub)
          .doc('$formattedDate $formattedTime ${getRandomString(2)}');
      // CollectionReference checkClassConstant =
      //     FirebaseFirestore.instance.collection('all_attendance_constants');
      // var checkStatus = await checkClassConstant.get().then((snapshot) {
      //   bool found = false;
      //   for (var doc in snapshot.docs) {
      //     if (doc.id == selectedItem) {
      //       found = true;
      //     }
      //   }
      //   return found;
      // });
      // if (!checkStatus) {
      //   await FirebaseFirestore.instance
      //       .collection('all_attendance_constants')
      //       .doc(className)
      //       .set({'hola': 'Hey'});
      //   await classConst.set(json);
      //   await FirebaseFirestore.instance
      //       .collection('all_attendance_constants')
      //       .doc(className)
      //       .update({'hola': FieldValue.delete()});
      // } else {
      await classConst.set(json);
      // }
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Expanded(child: Text('Today Attendance')),
            TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.green[900]),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: const Text('Confirm'),
                          content:
                              const Text('Are you sure you want to save? '),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel')),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  saveAttendance(classRange, selectedItem!,
                                      colorState, selectedSubject!);
                                  Navigator.pop(context);
                                },
                                child: const Text('Confirm'))
                          ],
                        ));
              },
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            )
          ],
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc('devices')
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
                  children: [
                    Row(
                      children: [
                        const Expanded(
                            child: Text(
                          'Select Class',
                          style: TextStyle(fontSize: 22),
                        )),
                        Expanded(
                          child: DropdownButton<String>(
                            iconSize: 32,
                            isExpanded: true,
                            onChanged: (value) async {
                              setState(() {
                                selectedItem = value;
                              });
                              List<dynamic> fetchedData =
                                  await FirebaseFirestore.instance
                                      .collection('Users')
                                      .doc('devices')
                                      .collection(andId)
                                      .doc('data')
                                      .collection('class_constants')
                                      .where('className',
                                          isEqualTo: selectedItem)
                                      .get()
                                      .then((value) => value.docs
                                          .elementAt(0)
                                          .get('classRange'));
                              List<dynamic> fetchedSubjects =
                                  await FirebaseFirestore.instance
                                      .collection('Users')
                                      .doc('devices')
                                      .collection(andId)
                                      .doc('data')
                                      .collection('class_constants')
                                      .where('className',
                                          isEqualTo: selectedItem)
                                      .get()
                                      .then((value) => value.docs
                                          .elementAt(0)
                                          .get('subjectList'));
                              setState(() {
                                selectedSubject = null;
                                _subjectList = fetchedSubjects;
                                classRange = fetchedData;
                                colorState = List<bool>.filled(
                                    classRange.length, false,
                                    growable: true);
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
                      height: 10,
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
                      height: 20,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: classRange.length,
                        shrinkWrap: true,
                        itemBuilder: (__, int index) {
                          return ListTile(
                            leading:
                                const Icon(Icons.format_list_numbered_outlined),
                            title: Text(
                              'Roll No ${classRange[index]}',
                              style: TextStyle(
                                  fontSize: 18.5,
                                  color: colorState[index]
                                      ? Colors.green
                                      : Colors.red),
                            ),
                            trailing: Icon(
                                colorState[index] ? Icons.check : Icons.clear),
                            subtitle:
                                Text(colorState[index] ? 'Present' : 'Absent'),
                            onTap: () {
                              setState(() {
                                colorState[index] = !colorState[index];
                              });
                            },
                          );
                        },
                      ),
                    )
                  ],
                );
              } else {
                return const Center(
                  child: Text('Please Add Students'),
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
