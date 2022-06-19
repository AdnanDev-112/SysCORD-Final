import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddUser extends StatefulWidget {
  const AddUser({Key? key}) : super(key: key);

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final formkey = GlobalKey<FormState>();

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isAdmin = false;

  Future<void> create(
      String name, String email, String password, bool adminStatus) async {
    try {
      // Map<String, String> customHeaders = {"content-type": "application/json"};

      var url = Uri.parse('http://192.168.0.106:3000/createUser');
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            "email": email,
            "username": name,
            "password": password,
            "isAdmin": adminStatus
          }));
      print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');
      // final credential =
      //     await FirebaseAuth.instance.createUserWithEmailAndPassword(
      //   email: email,
      //   password: password,
      // );
      // print('This is Creds Returned');
      // print(credential);
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add User'),
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
                    if (value!.isEmpty) {
                      return ('Password is Required');
                    }
                    if (!regex.hasMatch(value)) {
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
                create(name.text, email.text, password.text, isAdmin);

                Navigator.pop(context);
              }
            },
            child: Text(
              'Add',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
