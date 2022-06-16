import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sysbin/modules/activity/inputfield_class.dart';

class AddActivity extends StatefulWidget {
  const AddActivity({Key? key}) : super(key: key);

  @override
  State<AddActivity> createState() => _AddActivityState();
}

class _AddActivityState extends State<AddActivity> {
  DateTime date = DateTime.now();
  var nowDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
  _newdate(BuildContext context) async {
    DateTime? datepicker = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: date,
        lastDate: DateTime(2100));

    if (datepicker != null && datepicker != date) {
      setState(() {
        date = datepicker;
        nowDate = DateFormat("yyyy-MM-dd").format(datepicker).toString();
      });
    }
  }

  final formkey = GlobalKey<FormState>();

  TextEditingController eventName = TextEditingController();
  TextEditingController startTime = TextEditingController();
  TextEditingController endTime = TextEditingController();
  TextEditingController desc = TextEditingController();

  // DB FUnction
  Future<void> create(String eventName, String date, String desc,
      String timeStamp, String startTime, String endTime) async {
    try {
      await FirebaseFirestore.instance.collection("upcoming_events").add({
        "eventName": eventName,
        "date": date,
        "desc": desc,
        "startTime": startTime,
        "endTime": endTime,
        'timestamp': timeStamp
      });
      await FirebaseFirestore.instance.collection("completed_events").add({
        "eventName": eventName,
        "date": date,
        "desc": desc,
        "startTime": startTime,
        "endTime": endTime,
        'timestamp': timeStamp
      });
    } catch (e) {
      print(e);
    }
  }

  // Time Pickers
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  String _endTime = "";
  String? startTimerText = '';
  String? endTimerText = '';
  _getTimeFromUser({required bool isStartTime}) async {
    var _pickedTime = await _showTimePicker();
    String _formattedTime = _pickedTime.format(context);
    if (_pickedTime == null) {
      print("Time Cancelled");
    } else if (isStartTime == true) {
      setState(() {
        startTimerText = _formattedTime;
        // _startTime = _formattedTime;
        // startTime.text = _formattedTime;
        startTime.value = TextEditingValue(text: _formattedTime);
        print(_startTime);
      });
    } else if (isStartTime == false) {
      setState(() {
        endTimerText = _formattedTime;
        // _endTime = _formattedTime;
        endTime.value = TextEditingValue(text: _formattedTime);
        // endTime.text = _formattedTime;
      });
    }
  }

  _showTimePicker() {
    return showTimePicker(
        initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime: TimeOfDay(
            hour: int.parse(_startTime.split(":")[0]),
            minute: int.parse(_startTime.split(":")[1].split(" ")[0])));
  }

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
    var tt = nowDate.toString();
    String timeStamp = '$tt $tempTime';
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Event'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formkey,
          child: Container(
            margin: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Event Title',
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: eventName,
                  maxLength: 30,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: ("Enter Event Title"),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please Fill the Required Field";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  'Select Date',
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                    onTap: () {
                      setState(() {
                        _newdate(context);
                      });
                    },
                    readOnly: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: (nowDate),
                    )),
                const SizedBox(
                  height: 10,
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
                                        controller: startTime,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Enter Time";
                                          } else {
                                            return null;
                                          }
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
                                            hintText: startTimerText,
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
                                      onPressed: () {
                                        _getTimeFromUser(isStartTime: true);
                                      },
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
                                        controller: endTime,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Enter Time";
                                          } else {
                                            return null;
                                          }
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
                                            hintText: endTimerText,
                                            hintStyle: GoogleFonts.lato(
                                              textStyle: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white,
                                                    width: 0)),
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white,
                                                    width: 0))),
                                      ),
                                    ),
                                    Container(
                                        child: IconButton(
                                      onPressed: () {
                                        _getTimeFromUser(isStartTime: false);
                                      },
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
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: desc,
                  maxLines: 8,
                  maxLength: 500,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: ("Enter the Event Description"),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please Fill the Required Field";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        color: Colors.transparent,
        child: BottomAppBar(
          color: Colors.transparent,
          child: ElevatedButton(
            onPressed: () {
              if (formkey.currentState!.validate()) {
                create(
                    eventName.text,
                    nowDate.toString(),
                    desc.text,
                    timeStamp,
                    // startTime.text, endTime.text);
                    _startTime,
                    _endTime);

                Navigator.pop(context);
              }
            },
            child: Text(
              'Add',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
