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
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              mainAxisExtent: 175),
          children: [
            // Latest
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddSubject()));
              },
              child: Column(
                children: [
                  Container(
                    height: 125,
                    // width: 200,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0),
                        ),
                        image: DecorationImage(
                            image: AssetImage("assets/Add.jpg"),
                            fit: BoxFit.fill)),
                  ),
                  Container(
                    height: 50,
                    width: 190,
                    child: const Center(
                        child: Text(
                      "Add Subjects",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    )),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 224, 223, 223),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15.0),
                        bottomRight: Radius.circular(15.0),
                      ),
                    ),
                  )
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TakeAttendance(andId: andId!)));
              },
              child: Column(
                children: [
                  Container(
                    height: 125,
                    // width: 200,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0),
                        ),
                        image: DecorationImage(
                            image: AssetImage("assets/take.jpg"),
                            fit: BoxFit.fill)),
                  ),
                  Container(
                    height: 50,
                    width: 190,
                    child: const Center(
                        child: Text(
                      "Take  Attendance",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    )),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 224, 223, 223),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15.0),
                        bottomRight: Radius.circular(15.0),
                      ),
                    ),
                  )
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewHome(andId: andId!)));
              },
              child: Column(
                children: [
                  Container(
                    height: 125,
                    // width: 200,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0),
                        ),
                        image: DecorationImage(
                            image: AssetImage("assets/view.jpg"),
                            fit: BoxFit.fill)),
                  ),
                  Container(
                    height: 50,
                    width: 190,
                    child: const Center(
                        child: Text(
                      "View Records",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    )),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 224, 223, 223),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15.0),
                        bottomRight: Radius.circular(15.0),
                      ),
                    ),
                  )
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MonthHome(andId: andId!)));
              },
              child: Column(
                children: [
                  Container(
                    height: 125,
                    // width: 200,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0),
                        ),
                        image: DecorationImage(
                            image: AssetImage("assets/month.jpg"),
                            fit: BoxFit.fill)),
                  ),
                  Container(
                    height: 50,
                    width: 190,
                    child: const Center(
                        child: Text(
                      "Monthly Records",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    )),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 224, 223, 223),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15.0),
                        bottomRight: Radius.circular(15.0),
                      ),
                    ),
                  )
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TotalPage(andId: andId!)));
              },
              child: Column(
                children: [
                  Container(
                    height: 125,
                    // width: 200,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0),
                        ),
                        image: DecorationImage(
                            image: AssetImage("assets/excel.jpg"),
                            fit: BoxFit.fill)),
                  ),
                  Container(
                    height: 50,
                    width: 190,
                    child: const Center(
                        child: Text(
                      "Excel Report",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    )),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 224, 223, 223),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15.0),
                        bottomRight: Radius.circular(15.0),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
