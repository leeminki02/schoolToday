import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class Meal {
  final String foodsList;
  final String calories;
  final String nutritions;

  Meal({this.foodsList, this.calories, this.nutritions});

  factory Meal.fromJson(Map<String, dynamic> json) {
    // var foodsFromJson = json['DDISH_NM'];
    // List<String> foodsListfromJSON = foodsFromJson.cast<String>();
    return new Meal(
      foodsList: json["DDISH_NM"],
      calories: json['CAL_INFO'],
      nutritions: json['NTR_INFO'],
    );
  }
}

var now = new DateTime.now();
String today = (now.year * 10000 + now.month * 100 + now.day).toString();

Future<Meal> fetchLunch() async {
  final response = await http.get(
      'https://open.neis.go.kr/hub/mealServiceDietInfo?Type=json&KEY=f8695107c89049538bf22c059faeb9a1&MLSV_YMD=' +
          today +
          '&ATPT_OFCDC_SC_CODE=D10&SD_SCHUL_CODE=7240085&MMEAL_SC_CODE=2');
  if (response.statusCode == 200) {
    Map<String, dynamic> map = json.decode(response.body);
    List<dynamic> data = map["mealServiceDietInfo"];
    // print(today);
    return Meal.fromJson(data[1]["row"][0]);
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
                        color: Colors.grey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('안녕하세요, 이민기님!',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white)),
                            Text(
                                now.year.toString() +
                                    '.' +
                                    now.month.toString() +
                                    '.' +
                                    now.day.toString(),
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
                      color: Colors.grey,
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
                      color: Colors.grey,
                      child: Container(child: Text('시간표')),
                    ),
                    Card(
                      elevation: 5,
                      margin: EdgeInsets.all(10),
                      color: Colors.grey,
                      child: Container(
                          child: FutureBuilder<Meal>(
                              future: futureLunch,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Column(children: <Widget>[
                                    Text(snapshot.data.foodsList
                                        .replaceAll('<br/>', '\n')),
                                    Text(snapshot.data.calories),
                                    Text(snapshot.data.nutritions)
                                  ]);
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
