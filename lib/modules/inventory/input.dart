import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class Inputpage extends StatefulWidget {
  const Inputpage({Key? key}) : super(key: key);

  @override
  State<Inputpage> createState() => _InputpageState();
}

class _InputpageState extends State<Inputpage> {
  DateTime date = DateTime.now();
  var nowDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
  _newdate(BuildContext context) async {
    DateTime? datepicker = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));

    if (datepicker != null && datepicker != date) {
      setState(() {
        date = datepicker;
        nowDate = DateFormat("yyyy-MM-dd").format(datepicker).toString();
      });
    }
  }

  final formkey = GlobalKey<FormState>();

  TextEditingController name = TextEditingController();
  TextEditingController supplier = TextEditingController();
  TextEditingController quantity = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController desc = TextEditingController();

  // DB FUnction
  Future<void> create(String name, String date, String supplier,
      String quantity, String amount, String desc, String timeStamp) async {
    try {
      await FirebaseFirestore.instance.collection("INV").add({
        "name": name,
        "date": date,
        "supplier": supplier,
        "quantity": quantity,
        "amount": amount,
        "desc": desc,
        'timestamp': timeStamp
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Date Format
    DateTime _date = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    //Todays Date
    late String formattedDate = formatter.format(_date);
    // The Time
    String formattedTime = DateFormat('hh:mm a').format(DateTime.now());
    String tempTime = DateFormat('hh:mm').format(DateTime.now());
    var tt = nowDate.toString();
    String timeStamp = '$tt $tempTime';
    return Scaffold(
      appBar: AppBar(
        title: Text('Form'),
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
                    labelText: ("Enter the Name"),
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
                    onTap: () {
                      setState(() {
                        _newdate(context);
                      });
                    },
                    readOnly: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: (nowDate),
                    )),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: supplier,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: ("Enter the Name of the Supplier"),
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
                  controller: quantity,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: ("Enter the Quantity"),
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
                  controller: amount,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: ("Enter the Amount"),
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
                  controller: desc,
                  maxLines: 8,
                  maxLength: 300,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: ("Enter the Item Description"),
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
                create(name.text, nowDate.toString(), supplier.text,
                    quantity.text, amount.text, desc.text, timeStamp);

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
