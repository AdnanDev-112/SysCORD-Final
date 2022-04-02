import 'package:flutter/material.dart';

class InventoryHome extends StatefulWidget {
  const InventoryHome({Key? key}) : super(key: key);

  @override
  State<InventoryHome> createState() => _InventoryHomeState();
}

class _InventoryHomeState extends State<InventoryHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            Expanded(
                child: Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    height: 50,
                    child: const Center(
                        child: Text(
                      'Total',
                      style:
                          TextStyle(fontSize: 21, fontWeight: FontWeight.w600),
                    )))),
            Expanded(
                flex: 2,
                child: Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    height: 50,
                    child: Center(
                        child: Row(
                      children: const [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              ' ₹',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            '192000000000',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 20,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ],
                    )))),
          ],
        ),
      ),
    );
  }
}
