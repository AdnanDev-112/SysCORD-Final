import 'package:flutter/material.dart';
import 'package:sysbin/modules/activity/add_activity.dart';
import 'package:sysbin/modules/activity/completed_page.dart';
import 'package:sysbin/modules/activity/upcoming_page.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ActivityHome extends StatefulWidget {
  const ActivityHome({Key? key}) : super(key: key);

  @override
  State<ActivityHome> createState() => _ActivityHomeState();
}

class _ActivityHomeState extends State<ActivityHome> {
  bool isCompletedSelected = false;

  // Notifications
  FlutterLocalNotificationsPlugin flutterNoti =
      FlutterLocalNotificationsPlugin();
  void initState() {
    super.initState();
    var androidInitialize = AndroidInitializationSettings('app_icon');
    var iOSInit = IOSInitializationSettings();
    var initializationSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInit);
    flutterNoti.initialize(
      initializationSettings,
      // onSelectNotification: notificationSelected
    );
  }

  _showNotification() async {
    var androidDetails = AndroidNotificationDetails(
        'Channel ID', 'Channel Name',
        importance: Importance.max);
    var iOSDetails = IOSNotificationDetails();
    var genralNotificationDetails =
        NotificationDetails(android: androidDetails, iOS: iOSDetails);

// Show the Noti
    // await flutterNoti.show(
    //     0, 'Test', 'This is a TEST', genralNotificationDetails);
    var scheduledTime = DateTime.now().add(Duration(seconds: 5));

    await flutterNoti.schedule(
        0, 'Test', 'This is a TEST', scheduledTime, genralNotificationDetails);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: Text(''),
          actions: [
            // InkWell(
            //   onTap: () {
            //     print('Clicked');
            //     _showNotification();
            //   },
            //   child: const Icon(
            //     Icons.notifications,
            //     size: 36,
            //   ),
            // ),
          ]),
      body: Column(
        children: [
          Row(children: [
            Expanded(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(width: 2.5),
                  gradient: isCompletedSelected
                      ? null
                      : LinearGradient(colors: [
                          Color.fromARGB(255, 42, 114, 46),
                          Colors.green
                        ]),
                ),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isCompletedSelected = false;
                      });
                    },
                    child: const Text(
                      'Upcoming',
                      style: TextStyle(
                        fontSize: 20,
                        // decoration: isCompletedSelected
                        //     ? TextDecoration.none
                        //     : TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    border: Border.all(width: 2.5),
                    gradient: isCompletedSelected
                        ? LinearGradient(colors: [
                            Color.fromARGB(255, 42, 114, 46),
                            Colors.green
                          ])
                        : null),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isCompletedSelected = true;
                      });
                    },
                    child: const Text(
                      'Completed',
                      style: TextStyle(
                        fontSize: 20,
                        // decoration: isCompletedSelected
                        //     ? TextDecoration.underline
                        //     : TextDecoration.none,
                      ),
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

  // Future notificationSelected(String payload) async {}
}
