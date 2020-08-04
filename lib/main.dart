import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Meal {
  final String foodsList;
  final String calories;
  final String nutritions;

  Meal({this.foodsList, this.calories, this.nutritions});

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      foodsList: json['DDISH_NM'],
      calories: json['CAL_INFO'],
      nutritions: json['NTR_INFO'],
    );
  }
}

Future<Meal> fetchMeals(lord) async {
  final response = await http.get(
      'https://open.neis.go.kr/hub/mealServiceDietInfo?Type=json&KEY=f8695107c89049538bf22c059faeb9a1&MLSV_YMD=20200805&ATPT_OFCDC_SC_CODE=D10&SD_SCHUL_CODE=7240085&MMEAL_SC_CODE=' +
          lord);
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

/*
class _MyAppState extends State<MyApp>{

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}
*/
// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);
//   final String title;
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

class _MyAppState extends State<MyApp> {
  Future<Meal> futureLunch, futureDinner;

  @override
  void initState() {
    super.initState();
    futureLunch = fetchMeals('2');
    futureDinner = fetchMeals('3');
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
            /*
        appBar: AppBar(
          title: Text(
            '이민기님의 학교생활',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        */
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
                                  return Text(snapshot.data.foodsList);
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

/*
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        /*
        appBar: AppBar(
          title: Text(
            '이민기님의 학교생활',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        */
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
                            style:
                                TextStyle(fontSize: 15, color: Colors.white)),
                        Text('2020.08.04. 화요일',
                            style:
                                TextStyle(fontSize: 30, color: Colors.white)),
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
                    child: Text('급식 식단'),
                  ),
                ),
              ],
            ),
          ),
        ),
        /*
        floatingActionButton: FloatingActionButton(
          onPressed: null,
          child: Icon(
            Icons.settings,
            color: Colors.white,
          ),
          backgroundColor: Colors.grey,
        ),
        */
        // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
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
              /*
              SizedBox( //dummy box for floatingbtn if needed
                width: 40,
                child: null,
              )
              */
            ],
          ),
          // shape: CircularNotchedRectangle(),
        ));
  }
}
*/
