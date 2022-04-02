import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sysbin/models/attendance/attendance_model.dart';
import 'package:unique_identifier/unique_identifier.dart';

class AddSubject extends StatefulWidget {
  const AddSubject({Key? key}) : super(key: key);

  @override
  State<AddSubject> createState() => _AddSubjectState();
}

class _AddSubjectState extends State<AddSubject> {
  String? andId;
  @override
  void initState() {
    super.initState();
    getID();
  }

  getID() async {
    andId = await UniqueIdentifier.serial;
  }

  final _formkey = GlobalKey<FormState>();
  TextEditingController className = TextEditingController();
  TextEditingController firstRangeVal = TextEditingController();
  TextEditingController secondRangeVal = TextEditingController();

// Subject list
  final List<String> _subjectList = [];

// Variables For TextController
  int _count = 1;
  final List<Map<String, dynamic>> _controllerValues = [];

  // Function to track Updates
  _onUpdate(int index, String val) async {
    int foundKey = -1;
    for (var map in _controllerValues) {
      if (map.containsKey("id")) {
        if (map["id"] == index) {
          foundKey = index;
          break;
        }
      }
    }
    if (-1 != foundKey) {
      _controllerValues.removeWhere((map) {
        return map["id"] == foundKey;
      });
    }
    Map<String, dynamic> json = {
      "id": index,
      "value": val,
    };
    _controllerValues.add(json);
  }

// Function to return Row
  _row(int index) {
    int displayNumber = ++index;
    return Row(
      children: [
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter Subject Name';
              }
              return null;
            },
            onChanged: (value) {
              _onUpdate(index, value);
            },
            decoration: InputDecoration(
              icon: const Icon(Icons.book),
              hintText: 'Subject $displayNumber',
            ),
          ),
        ),
        const SizedBox(width: 30),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Adding the Class in DB
    Future addStudentClass(
        List classRange, String className, List subjectList) async {
      final dbDoc = FirebaseFirestore.instance
          .collection(andId!)
          .doc('data')
          .collection('class_constants')
          .doc(className);

      // Class Initialized
      // final classDoc = AttendanceDoc(id: dbDoc.id, classRange: classRange, className: className);
      final classDoc = AttendanceModel(
          classRange: classRange,
          className: className,
          subjectList: _subjectList);

      final json = classDoc.toJson();
      await dbDoc.set(json);
    }

    // Temp func to add SubList

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Add Students'),
            ElevatedButton(
              onPressed: () async {
                if (_formkey.currentState!.validate()) {
                  var rangeNumbers = [
                    for (var i = int.parse(firstRangeVal.text);
                        i <= int.parse(secondRangeVal.text);
                        i++)
                      i
                  ];

                  for (var map in _controllerValues) {
                    _subjectList.add(map["value"]);
                  }
                  await addStudentClass(
                      rangeNumbers, className.text, _subjectList);
                  print('Done Check');
                  Navigator.pop(context);
                }
              },
              child: const Text(
                'Save',
                style: TextStyle(fontSize: 20.0),
              ),
              style: ElevatedButton.styleFrom(primary: Colors.orangeAccent),
            )
          ],
        ),
      ),
      body: Form(
        key: _formkey,
        child: ListView(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                hintText: 'Ex. TYBCA',
                labelText: 'Class',
              ),
              controller: className,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Roll No Range',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                    child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Range';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter(RegExp(r'^[0-9]*$'),
                        allow: true)
                  ],
                  controller: firstRangeVal,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    hintText: 'Ex. 19001',
                  ),
                )),
                const Text('To'),
                Expanded(
                    child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Range';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter(RegExp(r'^[0-9]*$'),
                        allow: true)
                  ],
                  controller: secondRangeVal,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    hintText: 'Ex. 19045',
                  ),
                )),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            const Text(
              'Subjects',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 50,
            ),

            ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(
                      height: 20,
                    ),
                shrinkWrap: true,
                itemCount: _count,
                itemBuilder: (context, index) {
                  return _row(index);
                }),
            const SizedBox(
              height: 50,
            ),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _count++;
                  });
                },
                child: const Text(
                  'Add Subject',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),

            // Add Fields here
          ],
        ),
      ),
    );
  }
}
