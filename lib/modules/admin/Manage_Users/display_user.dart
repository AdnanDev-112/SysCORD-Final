import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DisplayUser extends StatelessWidget {
  Map<String, dynamic> recData;
  DisplayUser({Key? key, required this.recData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var dt;
    // = DateTime.fromMillisecondsSinceEpoch(recData['created_at']);
    var d12;
    // = DateFormat('MM/dd/yyyy').format(dt);
    if (recData['created_at'] != null) {
      dt = DateTime.fromMillisecondsSinceEpoch(recData['created_at']);
      d12 = DateFormat('MM/dd/yyyy').format(dt);
    } else {
      d12 = "";
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('User Details'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 2,
                                  color: Colors.black,
                                ),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(35.0),
                                  child: Text(
                                    recData['name']
                                        .toString()
                                        .toUpperCase()
                                        .split("")[0],
                                    style: TextStyle(fontSize: 30),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Row(
                          children: [
                            Text("Name : ",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'sans-sheriff')),
                            Text(
                              " ${recData['name']}",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Row(
                          children: [
                            Text("Email:",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'sans-sheriff')),
                            Text(" ${recData['email']}",
                                style: TextStyle(
                                    fontSize: 18, fontFamily: 'sans-sheriff')),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Row(
                          children: [
                            Text("Joined On :",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'sans-sheriff')),
                            Text(" ${d12}",
                                style: TextStyle(
                                    fontSize: 18, fontFamily: 'sans-sheriff')),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
