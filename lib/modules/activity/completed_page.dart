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
                .orderBy('date', descending: true)
                .snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                if (snapshot.data!.docs.isNotEmpty) {
                  return ListView.separated(
                      separatorBuilder: (context, _) => SizedBox(height: 15),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (__, index) {
                        var data = snapshot.data!.docs[index].data();

                        return Container(
                          padding: EdgeInsets.all(2.0),
                          decoration: BoxDecoration(
                            border: Border.all(width: 2.0),
                            gradient: LinearGradient(colors: [
                              Color.fromARGB(255, 226, 228, 113),
                              Color.fromARGB(255, 253, 252, 205)
                            ]),
                          ),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ActivityDisplay(
                                            dbId: "",
                                            indexId: index,
                                            isComplete: true,
                                            data: data,
                                          )));
                            },
                            title: Text(
                              data['eventName'],
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            // subtitle: Text(data['date']),
                            // trailing: Text('10.00AM to 11.00AM'),
                            trailing: Text(data['date']),
                            // trailing: Text('10.00AM to 11.00AM'),
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
