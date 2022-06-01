import 'package:flutter/material.dart';
import 'package:sysbin/modules/activity/add_activity.dart';
import 'package:sysbin/modules/activity/completed_page.dart';
import 'package:sysbin/modules/activity/upcoming_page.dart';

class ActivityHome extends StatefulWidget {
  const ActivityHome({Key? key}) : super(key: key);

  @override
  State<ActivityHome> createState() => _ActivityHomeState();
}

class _ActivityHomeState extends State<ActivityHome> {
  bool isCompletedSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(children: [
            Expanded(
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isCompletedSelected = false;
                    });
                  },
                  child: Text(
                    'Upcoming',
                    style: TextStyle(
                      decoration: isCompletedSelected
                          ? TextDecoration.none
                          : TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isCompletedSelected = true;
                    });
                  },
                  child: Text(
                    'Completed',
                    style: TextStyle(
                      decoration: isCompletedSelected
                          ? TextDecoration.underline
                          : TextDecoration.none,
                    ),
                  ),
                ),
              ),
            )
          ]),
          isCompletedSelected ? CompletedPage() : UpcomingPage(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddActivity()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
