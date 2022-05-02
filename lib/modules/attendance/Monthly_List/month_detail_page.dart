import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class MonthDetailPage extends StatelessWidget {
  final Map<String, dynamic> recievedData;

  const MonthDetailPage({Key? key, required this.recievedData})
      : super(key: key);
  // percentage Calculator
  double percentCalc() {
    int x = recievedData['totalClassesTaken'];
    if (x == 0) return 0.0;
    int y = recievedData['totalPresent'];
    double result = y / x;
    double tt = double.parse(result.toStringAsFixed(2));
    return tt;
  }

  // Percentage String
  String convertPercentage() {
    var a = percentCalc() * 100;
    return a.toInt().toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Column(
            children: [
              Row(
                children: const [
                  Expanded(
                      child: Text(
                    'Roll No ',
                    style: TextStyle(fontSize: 34),
                  ))
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    recievedData['rollNo'].toString(),
                    style: TextStyle(fontSize: 40),
                    textAlign: TextAlign.center,
                  ))
                ],
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 20.0),
                  child: Container(
                    color: Colors.yellow,
                    height: 120,
                    child: Row(
                      children: [
                        Expanded(
                          child: CircularPercentIndicator(
                            radius: 58,
                            lineWidth: 12,
                            percent: percentCalc(),
                            center: Text(
                              convertPercentage() + '%',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            circularStrokeCap: CircularStrokeCap.round,
                            progressColor: Colors.green,
                            backgroundColor: Colors.redAccent,
                            animation: true,
                            animationDuration: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Days Present : ${recievedData['totalPresent'].toString()}',
                style: const TextStyle(fontSize: 25),
              ),
              Text(
                'Days Absent : ${recievedData['totalAbsent'].toString()}',
                style: const TextStyle(fontSize: 25),
              ),
            ],
          )
        ],
      ),
    );
  }
}
