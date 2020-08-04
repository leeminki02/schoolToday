import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
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

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);
//   final String title;
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '이민기님의 학교생활',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: Center(
          // heightFactor: 0.9,
          child: FractionallySizedBox(
            widthFactor: 0.8,
            child: Card(
              margin: EdgeInsets.only(top: 20, bottom: 20),
              child: Column(
                children: <Widget>[
                  Text('Hello 1'),
                  Text('Hello 2'),
                  Text('Hello 3'),
                  Text('Hello 4'),
                ],
              ),
            ),
          ),

          /*
          Card(
            child: Column(
              children: <Widget>[
                // Container(
                FractionallySizedBox(
                    // alignment: Alignment.center,
                    widthFactor: 1.0,
                    child: Container(
                      height: 150,
                      color: Colors.blueAccent[100],
                      child: Text('맑음'),
                    ))
              ],
            ),
            margin: EdgeInsets.all(20),
          ),
*/
        ),
        /*floatingActionButton: FloatingActionButton(
          onPressed: null,
          tooltip: 'Increment',
          child: Icon(
            Icons.settings,
            color: Colors.white,
          ),
          backgroundColor: Colors.grey,
        ),*/
        // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.local_dining),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.wb_sunny),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.schedule),
                onPressed: () {},
              ),
            ],
          ),
          // shape: CircularNotchedRectangle(),
        ));
  }
}
