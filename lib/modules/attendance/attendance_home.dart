import 'package:flutter/material.dart';
import 'package:sysbin/modules/attendance/Add_Subject/add_subject.dart';
import 'package:sysbin/modules/attendance/Take_Attendance/take_attendance.dart';
import 'package:sysbin/modules/attendance/Total_all_subjects/total_page.dart';
import 'package:sysbin/modules/attendance/View_List/view_home.dart';
import 'package:unique_identifier/unique_identifier.dart';

import 'Monthly_List/month_view_home.dart';

class AttendanceHome extends StatelessWidget {
  const AttendanceHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // unique ID
    String? andId;

    getID() async {
      andId = await UniqueIdentifier.serial;
    }

    getID();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10),
          children: [
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddSubject()));
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.add,
                      size: 70,
                    ),
                    Text(
                      'Add Subjects',
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TakeAttendance(andId: andId!)));
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.orange,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.check,
                      size: 70,
                    ),
                    Text(
                      'Take Attendance',
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewHome(andId: andId!)));
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.pink,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.description,
                      size: 70,
                    ),
                    Text(
                      'View',
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MonthHome(andId: andId!)));
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.yellow,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.description,
                      size: 70,
                    ),
                    Text(
                      'Month',
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TotalPage(andId: andId!)));
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.blue,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.description,
                      size: 70,
                    ),
                    Text(
                      'Total',
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
