import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
// import 'package:google_fonts/google_fonts.dart'; //NOTE: NanumGothic 사용하기

//NOTE: initial value sets
var now = new DateTime.now();
// String dpday = (now.year * 10000 + now.month * 100 + now.day).toString();
// NOTE: temporary
String dpday = '20200918';
String today = dpday;
bool allergiestrue = false;

// NOTE: call data
class Meal {
  final String foodsList;
  final String calories;
  final String nutritions;
  Meal({this.foodsList, this.calories, this.nutritions});
  factory Meal.fromJson(Map<String, dynamic> json) {
    return new Meal(
      foodsList: json["DDISH_NM"],
      calories: json['CAL_INFO'],
      nutritions: json['NTR_INFO'],
    );
  }
}

class Event {
  final String eventName;
  final String eventDetail;
  Event({this.eventName, this.eventDetail});
  factory Event.fromJson(Map<String, dynamic> json) {
    return new Event(
        eventName: json["EVENT_NM"], eventDetail: json["EVENT_CNTNT"]);
  }
}

class Ttable {
  final List timetbl;
  Ttable({this.timetbl});
  // Ttable({this.tperiod, this.tcontent});
  factory Ttable.fromJson(List<dynamic> json) {
    return new Ttable(timetbl: json);
    // return new Ttable(tperiod: json['PERIO'], tcontent: json['ITRT_CNTNT']);
  }
}

//NOTE: 급식
Future<Meal> fetchLunch() async {
  final response = await http.get(
      'https://open.neis.go.kr/hub/mealServiceDietInfo?Type=json&KEY=f8695107c89049538bf22c059faeb9a1&ATPT_OFCDC_SC_CODE=D10&SD_SCHUL_CODE=7240085&MMEAL_SC_CODE=2&MLSV_YMD=' +
          dpday);
  if (response.statusCode == 200) {
    Map<String, dynamic> map = json.decode(response.body);
    List<dynamic> data = map["mealServiceDietInfo"];
    if (data != null) {
      return Meal.fromJson(data[1]["row"][0]);
    } else {
      return Meal(foodsList: '급식 정보가 없습니다.');
    }
  } else {
    throw Exception('Failed');
  }
}

Future<Ttable> fetchTable() async {
  final response = await http.get(
      'https://open.neis.go.kr/hub/hisTimetable?KEY=f8695107c89049538bf22c059faeb9a1&ATPT_OFCDC_SC_CODE=D10&SD_SCHUL_CODE=7240085&GRADE=3&CLASS_NM=8&TYPE=JSON&ALL_TI_YMD=' +
          dpday);
  if (response.statusCode == 200) {
    Map<String, dynamic> map = json.decode(response.body);
    List<dynamic> data = map["hisTimetable"];
    if (map != null) {
      return Ttable.fromJson(data[1]["row"]);
    } else {
      return Ttable(timetbl: ['시간표 없음']);
    }
  } else {
    throw Exception('Failed table');
  }
}

//NOTE: 학사일정
Future<Event> fetchEvent() async {
  final response = await http.get(
      'https://open.neis.go.kr/hub/SchoolSchedule?KEY=f8695107c89049538bf22c059faeb9a1&ATPT_OFCDC_SC_CODE=D10&SD_SCHUL_CODE=7240085&Type=json&AA_YMD=' +
          dpday);
  if (response.statusCode == 200) {
    Map<String, dynamic> map = json.decode(response.body);

    try {
      List<dynamic> data = map["SchoolSchedule"];
      return Event.fromJson(data[1]["row"][0]);
    } catch (e) {
      print(e);
      return null;
    }
  } else {
    throw Exception('Failed');
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
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
  Future<Event> futureEvent;
  Future<Ttable> futureTable;

  @override
  void initState() {
    super.initState();
    futureLunch = fetchLunch();
    futureEvent = fetchEvent();
    futureTable = fetchTable();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'NanumGothic',
        ),
        builder: (context, child) {
          return ScrollConfiguration(
            behavior: MyBehavior(),
            child: child,
          );
        },
        home: Scaffold(
            // appBar: ,
            body: SafeArea(
              child: SingleChildScrollView(
                // heightFactor: 0.9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    // #NOTE: 상단 intro, 학사일정
                    Container(
                        padding: EdgeInsets.all(20),
                        margin: EdgeInsets.only(bottom: 10),
                        color: Color.fromRGBO(76, 170, 151, 1),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('안녕하세요, 이민기님!',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontFamily: 'NanumGothic')),
                            Text(
                                now.year.toString() +
                                    '년 ' +
                                    now.month.toString() +
                                    '월 ' +
                                    now.day.toString() +
                                    '일',
                                style: TextStyle(
                                    fontSize: 30, color: Colors.white)),
                            FutureBuilder<Event>(
                                future: futureEvent,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(snapshot.data.eventName,
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.white));
                                  } else if (snapshot.hasError) {
                                    return Text('${snapshot.error}');
                                  } else if (!snapshot.hasData) {
                                    return Text(
                                      '오늘도 행복한 학교생활 하세요',
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.white),
                                    ); //FIXME: 일정이 없을 때 띄울 표현?
                                  } else {
                                    return Text('Loading..');
                                  }
                                }),
                          ],
                        )),
                    // NOTE: 날씨정보
                    Card(
                      elevation: 5,
                      margin: EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 5),
                      //NOTE: margin 바꿔보면서 깔끔한 배치 찾기
                      // color: Colors.red[200],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: Text(
                              'Weather',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            height: 120,
                            // width: 600,
                            child: ListView.builder(
                              padding: EdgeInsets.only(bottom: 10),
                              itemCount: 8,
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text((index * 3 + 9).toString() + '시'),
                                      // Text((index * 300).toString()),
                                      Icon(
                                        Icons.cloud,
                                        color: Colors.grey,
                                      ),
                                      Text('26°C'), //3시간기온
                                      // Text('강수확률 100%'), // 필요할까?
                                      Text('습도 85%'),
                                      Text('5m/s')
                                    ],
                                  ),
                                  padding: EdgeInsets.all(10),
                                  width: 90,
                                  alignment: Alignment.topCenter,
                                  /*decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black,
                                          style: BorderStyle.solid,
                                          width: 1)),*/
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(
                              '08월 07일 오전 05:00 예보 기준입니다. 제공: 기상청',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),

                    //NOTE: 급식메뉴
                    Card(
                      elevation: 5,
                      margin: EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 5),
                      //NOTE: margin 바꿔보면서 깔끔한 배치 찾기
                      // color: Colors.brown[200],
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: Text(
                              '오늘의 급식',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: FutureBuilder<Meal>(
                              //NOTE:FutureBuilder sample
                              future: futureLunch,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  List<String> foods =
                                      snapshot.data.foodsList.split('<br/>');
                                  List<int> allergies = [];
                                  for (var i = 0; i < foods.length; i++) {
                                    if (foods[i].contains('1.') |
                                        foods[i].contains('9.')) {
                                      allergies.add(i);
                                    }
                                  }
                                  return ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    padding: EdgeInsets.all(10),
                                    itemCount: foods.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      if (allergies.contains(index)) {
                                        allergiestrue = true;
                                        return Text(
                                          foods[index],
                                          style: TextStyle(
                                              fontSize: 15,
                                              // backgroundColor: Colors.black,
                                              color: Colors.deepOrange[700]),
                                        );
                                      } else {
                                        return Text(
                                          foods[index],
                                          style: TextStyle(fontSize: 15),
                                        );
                                      }
                                    },
                                  );
                                } else if (snapshot.hasError) {
                                  return Text("${snapshot.error}");
                                }
                                return Text('loading..');
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: Text(
                              '붉은 색으로 표시 된 음식은 알레르기 반응이 일어날 수 있어요!',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.redAccent[700]),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //NOTE: 시간표
                    Card(
                      elevation: 5,
                      margin: EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 5),
                      //NOTE: margin 바꿔보면서 깔끔한 배치 찾기
                      // color: Colors.green,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              '오늘의 시간표',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: FutureBuilder<Ttable>(
                              future: futureTable,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  // print(snapshot.data.timetbl[0]["ITRT_CNTNT"]);
                                  // List tbltbl = [];
                                  // for (var i = 0;
                                  //     i < snapshot.data.timetbl.length;
                                  //     i++) {
                                  //   // tbltbl.add(snapshot.data.timetbl[i]);
                                  // }
                                  return ListView.builder(
                                    itemCount: snapshot.data.timetbl.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                        child: Text(snapshot.data.timetbl[index]
                                                ["PERIO"] +
                                            "교시: " +
                                            snapshot.data.timetbl[index]
                                                ["ITRT_CNTNT"]),
                                        padding: EdgeInsets.all(4),
                                        width: 100,
                                      );
                                    },
                                    // scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                  );
                                } else {
                                  return Text('Load');
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    Card(
                        elevation: 5,
                        margin: EdgeInsets.only(
                            left: 10, right: 10, top: 5, bottom: 5),
                        //NOTE: margin 바꿔보면서 깔끔한 배치 찾기
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child: Text(
                                '주변 교통상황',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(20),
                              child: IntrinsicHeight(
                                  child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.subway,
                                        size: 50,
                                        color: Colors.grey[800],
                                      ),
                                      Text('지하철 \n배차시간표',
                                          style: TextStyle(fontSize: 15),
                                          textAlign: TextAlign.center),
                                    ],
                                  ),
                                  VerticalDivider(
                                    color: Colors.grey,
                                    width: 1,
                                    thickness: 1,
                                    endIndent: 5,
                                    indent: 5,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(Icons.directions_bus,
                                          size: 50, color: Colors.grey[800]),
                                      Text('버스\n도착정보',
                                          style: TextStyle(fontSize: 15),
                                          textAlign: TextAlign.center),
                                    ],
                                  ),
                                  VerticalDivider(
                                    color: Colors.grey,
                                    width: 1,
                                    thickness: 1,
                                    endIndent: 5,
                                    indent: 5,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(Icons.traffic,
                                          size: 50, color: Colors.grey[800]),
                                      Text('도로\n교통정보',
                                          style: TextStyle(fontSize: 15),
                                          textAlign: TextAlign.center),
                                    ],
                                  ),
                                ],
                              )),
                            )
                          ],
                        )),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        '2020 이민기, All rights Reserved.',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
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
// Copyright leeminki02, All rights reserved.
