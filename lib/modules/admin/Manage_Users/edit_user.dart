import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditUser extends StatefulWidget {
  Map<String, dynamic> recData;
  String uid;

  EditUser({Key? key, required this.recData, required this.uid})
      : super(key: key);

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  final formkey = GlobalKey<FormState>();

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isAdmin = false;

  Future<void> create(String name, String email, String password,
      bool adminStatus, String uid) async {
    try {
      // Map<String, String> customHeaders = {"content-type": "application/json"};

      var url = Uri.parse('http://192.168.0.106:3000/updateUser');
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            "email": email,
            "username": name,
            "password": password,
            "isAdmin": adminStatus,
            "uid": uid
          }));
      print('Response status: ${response.statusCode}');
    } catch (e) {
      print(e);
    }
  }

  void toggleSwitch(bool value) {
    if (isAdmin == false) {
      setState(() {
        isAdmin = true;
      });
    } else {
      setState(() {
        isAdmin = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    name.text = widget.recData['name'];
    email.text = widget.recData['email'];
    if (widget.recData['role'] == 'admin') {
      isAdmin = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    String uid = widget.uid;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit User Details'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formkey,
          child: Container(
            margin: EdgeInsets.all(10),
            child: Column(
              children: [
                TextFormField(
                  controller: name,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: ("User Name , Ex Aman Mahale"),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please Fill the Required Field";
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: ("Enter the email"),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please Fill the Required Field";
                    }
                    if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                        .hasMatch(value)) {
                      return ('Please Enter a Valid Email');
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  // keyboardType: TextInputType.phone,
                  controller: password,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: ("Enter the password"),
                  ),
                  validator: (value) {
                    RegExp regex = RegExp(r'^.{6,}$');
                    // if (value!.isEmpty) {
                    //   return ('Password is Required');
                    // }
                    if (!regex.hasMatch(value!) && value.isNotEmpty) {
                      return ('Enter Valid Password(Min. 6 Characters)');
                    }
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(children: [
                  const Expanded(child: Center(child: Text('Is Admin ? '))),
                  Expanded(
                      child: Switch(value: isAdmin, onChanged: toggleSwitch))
                ]),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        color: Colors.transparent,
        child: BottomAppBar(
          color: Colors.transparent,
          child: ElevatedButton(
            onPressed: () {
              if (formkey.currentState!.validate()) {
                create(name.text, email.text, password.text, isAdmin, uid);

                Navigator.pop(context);
              }
            },
            child: Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
