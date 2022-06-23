import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class UserBoard extends StatefulWidget {
  bool isFromAdmin;
  UserBoard({Key? key, required this.isFromAdmin}) : super(key: key);

  @override
  State<UserBoard> createState() => _UserBoardState();
}

class _UserBoardState extends State<UserBoard> {
  bool isFromAdmin = true;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final isFromAdmin = widget.isFromAdmin;
    final User user = auth.currentUser!;
    print(user);

    if (isFromAdmin) {
      return Scaffold(
          appBar: AppBar(),
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
                                      user.displayName
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
                                " ${user.displayName}",
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
                              Text(" ${user.email}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'sans-sheriff')),
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
                              Text(
                                  " ${user.metadata.creationTime!.toString().split(" ")[0]}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'sans-sheriff')),
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
    // print("User Name ${user.metadata.creationTime}");
    return Scaffold(
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
                                user.displayName
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
                          " ${user.displayName}",
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
                        Text(" ${user.email}",
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
                        Text(
                            " ${user.metadata.creationTime!.toString().split(" ")[0]}",
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
