import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:sysbin/modules/activity/display_page.dart';
import 'package:sysbin/modules/activity/editactivity.dart';
import 'package:sysbin/providers/userroleprov.dart';

class UpcomingPage extends StatefulWidget {
  const UpcomingPage({Key? key}) : super(key: key);

  @override
  State<UpcomingPage> createState() => _UpcomingPageState();
}

class _UpcomingPageState extends State<UpcomingPage> {
  //DB Function Delete
  Future<void> delete(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection("upcoming_events")
          .doc(id)
          .delete();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isAdmin = Provider.of<UserRoleProvider>(context, listen: true).isAdmin;
    return Expanded(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('upcoming_events')
                .orderBy("date", descending: false)
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

                        // return Container(
                        //   decoration: BoxDecoration(border: Border.all()),
                        //   child: ListTile(
                        //     onTap: () {
                        //       Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //               builder: (context) => ActivityDisplay(
                        //                     indexId: index,
                        //                     isComplete: false,
                        //                     data: data,
                        //                   )));
                        //     },
                        //     title: Text(
                        //       data['eventName'],
                        //       style: TextStyle(
                        //         fontWeight: FontWeight.w700,
                        //       ),
                        //     ),
                        //     subtitle: Text(data['date']),
                        //     trailing: Text(
                        //         '${data['startTime']} to ${data['endTime']}'),
                        //   ),
                        // );
                        if (isAdmin) {
                          return Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(border: Border.all()),
                            margin: EdgeInsets.only(top: 10),
                            child: Column(children: [
                              Slidable(
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
                                                builder: (context) =>
                                                    EditActivityPage(
                                                      recievedData: data,
                                                      dbid: dbId[index].id,
                                                    )));
                                      },
                                    ),
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
                                          delete(dbId[index].id);
                                        }),
                                  ],
                                ),
                                child: Container(
                                  height: 50,
                                  color: Color.fromARGB(255, 225, 238, 221),
                                  child: InkWell(
                                    splashColor: Colors.blueAccent,
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ActivityDisplay(
                                                    dbId: dbId[index].id,
                                                    indexId: index,
                                                    isComplete: false,
                                                    data: data,
                                                  )));
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: Text(
                                                  'Date: ${data['date']}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            const Expanded(
                                              child: Center(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 8.0),
                                                  child: Text(
                                                    'Time',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          height: 34,
                                          color: Color.fromARGB(
                                              255, 231, 214, 214),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    'Name: ${data['eventName']} ',
                                                    textAlign: TextAlign.start,
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16),
                                                  )),
                                              Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    '${data['startTime']} to ${data['endTime']}',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 15),
                                                  )),
                                              // Expanded(
                                              //     child: Text(
                                              //         'End: ₹ ${data['endTime']} /-')),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                          );
                        } else {
                          return Container(
                            height: 50,
                            color: Color.fromARGB(255, 165, 240, 142),
                            child: InkWell(
                              splashColor: Colors.blueAccent,
                              onTap: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => Displaypage(
                                //       dEd: data,
                                //     ),
                                //   ),
                                // );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            'Date: ${data['date']}',
                                          ),
                                        ),
                                      ),
                                      const Expanded(
                                        child: Center(
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 8.0),
                                            child: Text(
                                              'Time',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: 34,
                                    color: Colors.white,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Expanded(
                                            flex: 2,
                                            child: Text(
                                              'Name: ${data['eventName']} ',
                                              textAlign: TextAlign.start,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14),
                                            )),
                                        Expanded(
                                            flex: 2,
                                            child: Text(
                                                '${data['startTime']} to ${data['endTime']}')),
                                        // Expanded(
                                        //     child: Text(
                                        //         'End: ₹ ${data['endTime']} /-')),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      });
                } else {
                  return const Center(child: Text('No Upcoming events'));
                }
              } else {
                return const Text('No Data Found');
              }
            }));
  }
}
