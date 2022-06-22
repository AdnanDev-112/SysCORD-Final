import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:sysbin/modules/admin/Manage_Users/display_user.dart';
import 'package:sysbin/modules/admin/Manage_Users/edit_user.dart';

class ManageUser extends StatefulWidget {
  const ManageUser({Key? key}) : super(key: key);

  @override
  State<ManageUser> createState() => _ManageUserState();
}

class _ManageUserState extends State<ManageUser> {
  Future<void> deleteUser(String id) async {
    try {
// Check User
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User user = auth.currentUser!;
      final currentUid = user.uid;

// Func
      if (id != currentUid) {
        var url = Uri.parse('http://192.168.0.106:3000/deleteUser');
        var response = await http.post(url,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, dynamic>{
              "id": id,
            }));
        print('Response status: ${response.statusCode}');
        if (response.statusCode == 200) {
          Fluttertoast.showToast(msg: 'User Deleted Sucessfully');
        } else {
          Fluttertoast.showToast(msg: 'Error Occured');
        }
      } else {
        Fluttertoast.showToast(msg: 'Cannot Delete Yourself');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users '),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('usersLogin')
              .orderBy("name", descending: false)
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              if (snapshot.data!.docs.isNotEmpty) {
                List dbId = [];
                for (int i = 0; i < snapshot.data!.docs.length; i++) {
                  // For Id's
                  dbId.add(snapshot.data!.docs[i]);
                }
                return ListView.separated(
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (__, index) {
                      var data = snapshot.data!.docs[index].data();
                      return Slidable(
                          key: ValueKey(index),
                          endActionPane: ActionPane(
                            motion: ScrollMotion(),
                            children: [
                              SlidableAction(
                                  backgroundColor: Colors.blue,
                                  label: "Edit",
                                  icon: Icons.edit,
                                  onPressed: (context) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => EditUser(
                                                  recData: data,
                                                  uid: dbId[index].id,
                                                )));
                                  }),
                            ],
                          ),
                          startActionPane: ActionPane(
                            motion: ScrollMotion(),
                            children: [
                              SlidableAction(
                                  backgroundColor: Colors.red,
                                  label: "Delete",
                                  icon: Icons.delete,
                                  onPressed: (_) {
                                    deleteUser(dbId[index].id);
                                  }),
                            ],
                          ),
                          child: Container(
                            padding: EdgeInsets.all(2.0),
                            decoration: BoxDecoration(
                              border: Border.all(width: 1.0),
                            ),
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DisplayUser(
                                              recData: data,
                                            )));
                              },
                              title: Text(
                                data['name'],
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                              subtitle: Text(
                                data['email'],
                                style: TextStyle(fontSize: 15),
                              ),
                              // trailing: Text('10.00AM to 11.00AM'),
                              trailing:
                                  Text(data['role'].toString().toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 16,
                                      )),
                              // trailing: Text('10.00AM to 11.00AM'),
                            ),
                          ));
                      // return Container(
                      //   padding: EdgeInsets.all(2.0),
                      //   decoration: BoxDecoration(
                      //     border: Border.all(width: 1.0),
                      //   ),
                      //   child: ListTile(
                      //     onTap: () {},
                      //     title: Text(
                      //       data['name'],
                      //       style: TextStyle(
                      //           fontSize: 18, fontWeight: FontWeight.w500),
                      //     ),
                      //     subtitle: Text(
                      //       data['email'],
                      //       style: TextStyle(fontSize: 15),
                      //     ),
                      //     // trailing: Text('10.00AM to 11.00AM'),
                      //     trailing: Text(data['role'].toString().toUpperCase(),
                      //         style: TextStyle(
                      //           fontSize: 16,
                      //         )),
                      //     // trailing: Text('10.00AM to 11.00AM'),
                      //   ),
                      // );
                    });
              } else {
                return const Center(child: Text('No Data Found'));
              }
            } else {
              return const Center(
                child: Text('No Users Found'),
              );
            }
          }),
    );
  }
}
