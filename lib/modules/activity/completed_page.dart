import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'display_page.dart';

class CompletedPage extends StatefulWidget {
  const CompletedPage({Key? key}) : super(key: key);

  @override
  State<CompletedPage> createState() => _CompletedPageState();
}

class _CompletedPageState extends State<CompletedPage> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('completed_events')
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
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ActivityDisplay(
                                          isComplete: true,
                                          data: data,
                                        )));
                          },
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
