import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sysbin/modules/activity/display_page.dart';

class UpcomingPage extends StatefulWidget {
  const UpcomingPage({Key? key}) : super(key: key);

  @override
  State<UpcomingPage> createState() => _UpcomingPageState();
}

class _UpcomingPageState extends State<UpcomingPage> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('upcoming_events')
                .snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                if (snapshot.data!.docs.isNotEmpty) {
                  return ListView.separated(
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 15),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (__, index) {
                        var data = snapshot.data!.docs[index].data();

                        return Container(
                          decoration: BoxDecoration(border: Border.all()),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ActivityDisplay(
                                            indexId: index,
                                            isComplete: false,
                                            data: data,
                                          )));
                            },
                            title: Text(data['eventName']),
                            subtitle: Text(data['date']),
                            trailing: Text(
                                '${data['startTime']} to ${data['endTime']}'),
                          ),
                        );
                      });
                } else {
                  return Container(child: const Text('No Data'));
                }
              } else {
                return Container(child: const Text('No Data Found'));
              }
            }));
  }
}
