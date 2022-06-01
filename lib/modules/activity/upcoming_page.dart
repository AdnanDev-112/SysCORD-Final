import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (__, index) {
                        var data = snapshot.data!.docs[index].data();

                        return ListTile(
                          title: Text(data['eventName']),
                          subtitle: Text(data['date']),
                          trailing: Text('10.00AM to 11.00AM'),
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
