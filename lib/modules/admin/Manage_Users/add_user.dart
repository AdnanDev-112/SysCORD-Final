import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

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

  Future<void> create(String name, String email, String password) async {
    print('g');
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
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: ("Enter the email"),
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
                  keyboardType: TextInputType.phone,
                  controller: password,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: ("Enter the password"),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please Fill the Required Field";
                    } else {
                      return null;
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
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        color: Colors.transparent,
        child: BottomAppBar(
          color: Colors.transparent,
          child: ElevatedButton(
            onPressed: () {
              if (formkey.currentState!.validate()) {
                create(
                  name.text,
                  email.text,
                  password.text,
                );

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
