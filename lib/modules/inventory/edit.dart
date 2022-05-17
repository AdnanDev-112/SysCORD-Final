import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Editpage extends StatefulWidget {
  Map<String, dynamic> eD;
  String dbid;
  Editpage({Key? key, required this.eD, required this.dbid}) : super(key: key);

  @override
  State<Editpage> createState() => _EditpageState();
}

class _EditpageState extends State<Editpage> {
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

//DB Function Update
  Future<void> update(String id, String name, String date, String supplier,
      String quantity, String amount, String desc) async {
    try {
      await FirebaseFirestore.instance.collection("INV").doc(id).update({
        "name": name,
        "date": date,
        "supplier": supplier,
        "quantity": quantity,
        "amount": amount,
        "desc": desc
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name.text = widget.eD['name'];
    nowDate = widget.eD['date'];
    supplier.text = widget.eD['supplier'];
    quantity.text = widget.eD['quantity'];
    amount.text = widget.eD['amount'];
    desc.text = widget.eD['desc'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Entry'),
      ),
      body: SingleChildScrollView(
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
                  )),
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
                  )),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                  keyboardType: TextInputType.phone,
                  controller: quantity,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: ("Enter the Quantity"),
                  )),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                  keyboardType: TextInputType.phone,
                  controller: amount,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: ("Enter the Amount"),
                  )),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                  controller: desc,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: ("Enter the Description"),
                  )),
            ],
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
              update(widget.dbid, name.text, nowDate.toString(), supplier.text,
                  quantity.text, amount.text, desc.text);

              Navigator.pop(context);
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
