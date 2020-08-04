import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class Meal {
  final String foodsList;
  // final String calories;
  // final String nutritions;

  Meal({this.foodsList});

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      foodsList: "json['mealServiceDietInfo']",
      // calories: json['CAL_INFO'],
      // nutritions: json['NTR_INFO'],
    );
  }
}

Future<Meal> fetchLunch() async {
  final response = await http.get(
      'https://open.neis.go.kr/hub/mealServiceDietInfo?Type=json&KEY=f8695107c89049538bf22c059faeb9a1&MLSV_YMD=20200805&ATPT_OFCDC_SC_CODE=D10&SD_SCHUL_CODE=7240085&MMEAL_SC_CODE=2');
  if (response.statusCode == 200) {
    return Meal.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed');
  }
}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<Meal> futureLunch;

  @override
  void initState() {
    super.initState();
    futureLunch = fetchLunch();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Scaffold(
            // appBar: ,
            body: SafeArea(
              child: SingleChildScrollView(
                // heightFactor: 0.9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.all(20),
                        color: Colors.blue,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('안녕하세요, 이민기님!',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white)),
                            Text('2020.08.04. 화요일',
                                style: TextStyle(
                                    fontSize: 30, color: Colors.white)),
                            Text('기말고사(1,3학년, 至 8/4)',
                                style: TextStyle(
                                    // fontStyle: FontStyle.italic,
                                    fontSize: 20,
                                    color: Colors.white))
                          ],
                        )),
                    Card(
                      elevation: 5,
                      margin: EdgeInsets.all(10),
                      color: Colors.green,
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Text('날씨 예보'),
                            Text('교내 기상관측 정보'),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      elevation: 5,
                      margin: EdgeInsets.all(10),
                      color: Colors.amber,
                      child: Container(child: Text('시간표')),
                    ),
                    Card(
                      elevation: 5,
                      margin: EdgeInsets.all(10),
                      color: Colors.brown,
                      child: Container(
                          child: FutureBuilder<Meal>(
                              future: futureLunch,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  try {
                                    return Text(
                                        snapshot.data.foodsList.toString());
                                  } catch (e) {
                                    return Text('Error#01' + e.toString());
                                  }
                                } else if (snapshot.hasError) {
                                  return Text("${snapshot.error}");
                                }

                                return CircularProgressIndicator();
                              })),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              color: Colors.white,
              child: Row(
                // mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.wb_sunny),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.hourglass_empty),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.alarm),
                    onPressed: () {},
                  ),
                ],
              ),
            )));
  }
}
