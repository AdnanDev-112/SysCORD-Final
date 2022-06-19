import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sysbin/modules/activity/activity_home.dart';
import 'package:sysbin/modules/inventory/inventory_home.dart';
import 'package:sysbin/providers/userroleprov.dart';
import 'package:sysbin/screens/dashboard.dart';
import 'package:sysbin/screens/login.dart';
import 'package:sysbin/services/userauth.dart';

import '../modules/attendance/attendance_home.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

enum DrawerSections { dashboard, activity, attendance, inventory }

class _HomeState extends State<Home> {
  var currentPage = DrawerSections.dashboard;
  String appBarText = 'SysCORD';
  // Logout function
  Future<void> logOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Provider.of<UserRoleProvider>(context, listen: false).setRole(false);
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    //
    final FirebaseAuth authh = FirebaseAuth.instance;
    final User user = authh.currentUser!;
    UserHelper().updateProvider(user, context);
    bool isAdmin =
        Provider.of<UserRoleProvider>(context, listen: false).isAdmin;
    //
    var container;
    if (currentPage == DrawerSections.dashboard && isAdmin) {
      container = DashBoard();
    } else if (currentPage == DrawerSections.attendance) {
      container = AttendanceHome();
    } else if (currentPage == DrawerSections.inventory) {
      container = InvHomePage();
    } else if (currentPage == DrawerSections.activity) {
      container = ActivityHome();
    }
    Widget menuItem(int id, String title, IconData icon, bool selected) {
      return Material(
        color: selected ? Colors.grey[300] : Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
            setState(() {
              if (id == 1) {
                currentPage = DrawerSections.dashboard;
                appBarText = 'SysCORD';
              } else if (id == 2) {
                currentPage = DrawerSections.attendance;
                appBarText = 'Attendance';
              } else if (id == 3) {
                currentPage = DrawerSections.activity;
                appBarText = 'Activity';
              } else if (id == 4) {
                appBarText = 'Inventory';
                currentPage = DrawerSections.inventory;
              } else if (id == 5) {
                logOut(context);
              }
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Icon(
                        icon,
                        size: 20,
                        color: Colors.black,
                      ),
                    ),
                    Expanded(
                        flex: 3,
                        child: Text(
                          title,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 16),
                        ))
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget myDrawerList() {
      return Container(
        padding: const EdgeInsets.only(top: 15),
        child: Column(children: [
          // Show the List of Menu Drawer
          if (isAdmin) ...[
            menuItem(1, "Dashboard", Icons.dashboard_customize_outlined,
                currentPage == DrawerSections.dashboard ? true : false)
          ],

          menuItem(2, "Attendance", Icons.badge,
              currentPage == DrawerSections.attendance ? true : false),
          menuItem(3, "Activity", Icons.event,
              currentPage == DrawerSections.activity ? true : false),
          menuItem(4, "Inventory", Icons.inventory,
              currentPage == DrawerSections.inventory ? true : false),
          menuItem(5, "LogOut", Icons.logout, false),
        ]),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarText),
      ),
      drawer: SafeArea(
        child: Drawer(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: Colors.green[200],
                  width: double.infinity,
                  height: 100,
                  child: const Center(
                    child: Text(
                      'SysCord ',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                myDrawerList()
              ],
            ),
          ),
        ),
      ),
      body: container,
    );
  }
}
