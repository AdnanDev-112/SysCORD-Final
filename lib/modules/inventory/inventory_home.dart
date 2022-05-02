import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sysbin/modules/inventory/display.dart';
import 'exp.dart';
import 'edit.dart';
import 'input.dart';

class InvHomePage extends StatefulWidget {
  InvHomePage({Key? key}) : super(key: key);

  @override
  State<InvHomePage> createState() => _InvHomePageState();
}

class _InvHomePageState extends State<InvHomePage> {
  String dropdownValue = 'Select value';
  String dropdownValue1 = '2018';
  List<String> MONTH = [
    "Select value",
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  List<String> YEAR = [
    '2018',
    '2019',
    '2020',
    '2021',
    '2022',
    '2023',
    '2024',
    '2025',
    '2026',
    '2027',
    '2028',
    '2029',
    '2030',
    '2031',
    '2032',
  ];

  //DB Function Delete
  Future<void> delete(String id) async {
    try {
      await FirebaseFirestore.instance.collection("INV").doc(id).delete();
    } catch (e) {
      print(e);
    }
  }

  //Excel
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int counterTest = 0;
    var add = 0;
    var tosendData = [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory'),
        actions: [
          IconButton(
            onPressed: () async {
              setState(() {
                createExcel(dropdownValue, dropdownValue1, tosendData);
                print(counterTest);
              });
            },
            icon: Icon(Icons.file_download),
          )
        ],

        // actions: [],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('INV').snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              if (snapshot.data!.docs.isNotEmpty) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        DropdownButton<String>(
                          value: dropdownValue,
                          style: const TextStyle(color: Colors.blueAccent),
                          underline: Container(
                            height: 2,
                            color: Colors.blue,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValue = newValue!;
                            });
                          },
                          items: MONTH
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        DropdownButton<String>(
                          value: dropdownValue1,
                          style: const TextStyle(color: Colors.blueAccent),
                          underline: Container(
                            height: 2,
                            color: Colors.blue,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValue1 = newValue!;
                            });
                          },
                          items: YEAR
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView.separated(
                          shrinkWrap: true,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 0),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, int index) {
                            var data = snapshot.data!.docs[index];

                            var ys = DateTime.parse(data['date']);

                            add = int.parse(data['quantity']) *
                                int.parse(data['amount']);
                            var gg = MONTH.indexOf(dropdownValue);
                            var gl = YEAR.indexOf(dropdownValue1);

                            if (ys.month == gg &&
                                ys.year == int.parse(dropdownValue1)) {
                              SchedulerBinding.instance!
                                  .addPostFrameCallback((_) {
                                setState(() {
                                  tosendData.add(data);
                                });
                              });

                              // tosendData.add(data);
                              return Container(
                                margin: EdgeInsets.only(top: 2, bottom: 10),
                                child: Column(
                                  children: [
                                    Slidable(
                                      key: ValueKey(index),
                                      endActionPane: ActionPane(
                                        motion: ScrollMotion(),
                                        children: [
                                          SlidableAction(
                                              backgroundColor: Colors.blue,
                                              label: "Edit",
                                              icon: Icons.edit,
                                              onPressed: (context) {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Editpage(
                                                              eD: data.data(),
                                                              dbid: data.id,
                                                            )));
                                              }),
                                        ],
                                      ),
                                      startActionPane: ActionPane(
                                        motion: ScrollMotion(),
                                        children: [
                                          SlidableAction(
                                              backgroundColor: Colors.red,
                                              label: "Delete",
                                              icon: Icons.delete,
                                              onPressed: (context) {
                                                delete(data.id);
                                              }),
                                        ],
                                      ),
                                      child: Container(
                                        height: 50,
                                        color: Colors.orangeAccent,
                                        child: InkWell(
                                          splashColor: Colors.blueAccent,
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Displaypage(
                                                          dEd: data.data(),
                                                        )));
                                          },
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: Text(
                                                  '${data['date']}',
                                                ),
                                              ),
                                              Container(
                                                height: 34,
                                                color: Colors.white,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Expanded(
                                                        flex: 2,
                                                        child: Text(
                                                          'Name: ${data['name']} ',
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 14),
                                                        )),
                                                    Expanded(
                                                        child: Text(
                                                            'Qty:  ${data['quantity']}')),
                                                    Expanded(
                                                        flex: 2,
                                                        child: Text(
                                                            'Amount: ₹ ${data['amount']} /-')),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      color: Color.fromARGB(137, 158, 171, 184),
                                      child: Table(
                                          border: TableBorder.all(
                                              color: Colors.black87,
                                              width: 2,
                                              style: BorderStyle.solid),
                                          children: [
                                            TableRow(children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      'Total',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.black87),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      '₹ ${add}/-',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.black87),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ]),
                                          ]),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return SizedBox(
                                height: 0,
                                width: 0,
                              );
                            }
                          }),
                    ),
                    Container(
                      color: Color.fromARGB(137, 158, 171, 184),
                      child: Table(
                          border: TableBorder.all(
                              color: Colors.black87,
                              width: 2,
                              style: BorderStyle.solid),
                          children: [
                            TableRow(children: [
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  children: [
                                    Text(
                                      'Total',
                                      style: TextStyle(color: Colors.black87),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(
                                      '₹ gg/-',
                                      style: TextStyle(color: Colors.black87),
                                    ),
                                  ],
                                ),
                              )
                            ]),
                          ]),
                    ),
                  ],
                );
              } else {
                return Container(child: Text('No Data'));
              }
            } else {
              return Container(child: Text('No Data Found'));
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Inputpage()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
