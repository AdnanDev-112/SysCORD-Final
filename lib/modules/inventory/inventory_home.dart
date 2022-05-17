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
  // New Variables
  String? _selectedMonth;
  String? _selectedYear;
  int? _selectedMonthInt;
  int? _selectedYearInt;
  //

  // NEw YEars
  List years = [2021, 2022, 2023, 2024, 2025, 2026];
  List monthNames = [
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
  bool isDescending = true;

  //DB Function Delete
  Future<void> delete(String id) async {
    try {
      await FirebaseFirestore.instance.collection("INV").doc(id).delete();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var tosendData = [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Entries'),
        actions: [
          InkWell(
            onTap: () {
              setState(() {
                isDescending = !isDescending;
              });
            },
            child: const Icon(
              Icons.compare_arrows,
              size: 36,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          InkWell(
            onTap: () {
              setState(() {
                _selectedMonth = null;
                _selectedYear = null;
                _selectedMonthInt = null;
                _selectedYearInt = null;
              });
            },
            child: const Icon(
              Icons.refresh,
              size: 36,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          InkWell(
              onTap: () async {
                if (_selectedMonth != null && _selectedYear != null) {
                  createExcel(_selectedMonth!, _selectedYear!, tosendData);
                } else {
                  createExcel(' ', ' ', tosendData);
                }
              },
              child: const Icon(
                Icons.file_download,
                size: 36,
              )),
        ],

        // actions: [],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('INV').snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              if (snapshot.data!.docs.isNotEmpty) {
                List<Map<String, dynamic>> mP = [];
                List<Map<String, dynamic>> sT = [];
                List dbID = [];
                List dbIDT = [];
                for (int i = 0; i < snapshot.data!.docs.length; i++) {
                  mP.add(snapshot.data!.docs[i].data());
                  sT.add(snapshot.data!.docs[i].data());
                  // For Id's
                  dbID.add(snapshot.data!.docs[i]);
                  dbIDT.add(snapshot.data!.docs[i]);
                }
                if (_selectedMonthInt != null && _selectedYearInt != null) {
                  List<Map<String, dynamic>> sTT = [];
                  List tempID = [];
                  for (int i = 0; i < mP.length; i++) {
                    if (DateTime.parse(mP[i]['date']).month ==
                            _selectedMonthInt &&
                        DateTime.parse(mP[i]['date']).year.toString() ==
                            _selectedYear) {
                      sTT.add(mP[i]);
                      tempID.add(dbID[i]);
                    }
                  }
                  mP = sTT;
                  dbID = tempID;
                } else if (_selectedYearInt != null) {
                  List<Map<String, dynamic>> sTT = [];
                  List tempID = [];
                  for (int i = 0; i < mP.length; i++) {
                    if (DateTime.parse(mP[i]['date']).year.toString() ==
                        _selectedYear) {
                      sTT.add(mP[i]);
                      tempID.add(dbID[i]);
                    }
                  }
                  mP = sTT;
                  dbID = tempID;
                } else {
                  mP = sT;
                  dbID = dbIDT;
                }

                mP.sort((a, b) {
                  var aa = DateTime.parse(a['date']);
                  var bb = DateTime.parse(b['date']);
                  return isDescending ? bb.compareTo(aa) : aa.compareTo(bb);
                });
                // Ids Sort?
                dbID.sort((a, b) {
                  var aa = DateTime.parse(a.data()['date']);
                  var bb = DateTime.parse(b.data()['date']);
                  return isDescending ? bb.compareTo(aa) : aa.compareTo(bb);
                });

                tosendData = mP;
                // Total
                int totalAmt = 0;

                for (int i = 0; i < mP.length; i++) {
                  totalAmt += (int.parse(mP[i]['amount']) *
                      int.parse(mP[i]['quantity']));
                }

                // S
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: DropdownButton(
                            hint: const Text('Month'),
                            isExpanded: true,
                            items: monthNames
                                .map((item) => DropdownMenuItem(
                                      child: Text(item),
                                      value: item,
                                    ))
                                .toList(),
                            value: _selectedMonth,
                            onChanged: (value) {
                              setState(() {
                                _selectedMonth = value.toString();
                                _selectedMonthInt =
                                    monthNames.indexOf(_selectedMonth) + 1;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: DropdownButton(
                            isExpanded: true,
                            hint: const Text('Year'),
                            value: _selectedYear,
                            items: years
                                .map((item) => DropdownMenuItem(
                                      child: Text(item.toString()),
                                      value: item.toString(),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedYear = value.toString();
                                _selectedYearInt =
                                    years.indexOf(_selectedYear) + 1;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView.separated(
                          shrinkWrap: true,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 15),
                          itemCount: mP.length,
                          itemBuilder: (__, int index) {
                            Map<String, dynamic> mainDoc = mP[index];

                            // if (ys.month == gg &&
                            //     ys.year == int.parse(dropdownValue1)) {
                            //   SchedulerBinding.instance!
                            //       .addPostFrameCallback((_) {
                            //     setState(() {
                            //       tosendData.add(data);
                            //     });
                            //   });

                            return Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(border: Border.all()),
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
                                                            eD: mainDoc,
                                                            dbid:
                                                                dbID[index].id,
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
                                            onPressed: (_) {
                                              delete(dbID[index].id);
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
                                                        dEd: mainDoc,
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
                                                'Date: ${mainDoc['date']}',
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
                                                        'Name: ${mainDoc['name']} ',
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14),
                                                      )),
                                                  Expanded(
                                                      child: Text(
                                                          'Qty:  ${mainDoc['quantity']}')),
                                                  Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                          'Amount Per: ₹ ${mainDoc['amount']} /-')),
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
                                              padding: const EdgeInsets.all(8),
                                              child: Column(
                                                children: const [
                                                  Text(
                                                    'Total',
                                                    style: TextStyle(
                                                        color: Colors.black87),
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
                                                    '₹ ${int.parse(mainDoc['quantity']) * int.parse(mainDoc['amount'])}/-',
                                                    style: const TextStyle(
                                                        color: Colors.black87),
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
                          }),
                    ),
                    const SizedBox(
                      height: 50,
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
                                  children: const [
                                    Text(
                                      'OverAll Total',
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
                                      '₹ $totalAmt /-',
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
                return Container(child: const Text('No Data'));
              }
            } else {
              return Container(child: const Text('No Data Found'));
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
