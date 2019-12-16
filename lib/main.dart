import 'package:flutter_app/Fetch.dart';
import 'package:flutter_app/WeaCondition.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/physics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/orientGrid.dart';
import 'package:flutter_app/JoAnim.dart';
import 'package:flutter_svg/flutter_svg.dart';

main() {
  runApp(MaterialApp(
    title: "JO JOO",
//    home: DefaultTabController(
//        length: 3,
//        child: Scaffold(
//          appBar: AppBar(
//            title: Text("joo shit"),
//            bottom: TabBar(
//              tabs: [
//                Tab(
//                  icon: Icon(Icons.directions_bike),
//                ),
//                Tab(
//                  icon: Icon(Icons.directions_run),
//                ),
//                Tab(
//                  icon: Icon(Icons.directions_bus),
//                ),
//              ],
//            ),
//          ),
//          body: TabBarView(children: [
//            Icon(Icons.directions_bike),
//            Center(
//                child: Text("second", style: TextStyle(fontSize: 70.0),
//            )),
//            Icon(Icons.directions_bus)
//          ]),
//        )),
    home: Joapp(),
  ));
}

class Joapp extends StatefulWidget {
  @override
  _JoappState createState() => _JoappState();
}

class _JoappState extends State<Joapp> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  Future<List<WeaCondition>> _future;

  @override
  void initState() {
    super.initState();
    _setFuture();
  }

  void _setFuture() {
    _future = Fetch.handleData(_scaffoldkey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: Text("Jo extreme"),
      ),
      backgroundColor: Colors.lightBlue[200],
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text("DRAWER HEADER"),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text("Item 1"),
              onTap: () {
                setState(() {
                  _future = Fetch.handleData(_scaffoldkey);
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Item 2"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _setFuture();
          });
        },
        child: Icon(Icons.refresh),
      ),
      body: FutureBuilder<List<WeaCondition>>(
        future: _future,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          print("Future builder go go");
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text('Press button to start.');
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              if (snapshot.hasError) return Text('Error: ${snapshot.error}');
              return _makeView(snapshot);
          }
          return null; // unreachable
        },
      ),
//      body: OrientGrid(),
//        body: JoAnim(),
    );
  }

  Widget _makeView(AsyncSnapshot snapshot) {
    List<WeaCondition> list = snapshot.data;

    return Container(
      transform: Matrix4.rotationZ(-0.05),
      margin: EdgeInsets.all(8.0),
      height: 200.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        itemBuilder: (context, index) {
          WeaCondition weaCondition = list.elementAt(index);
          return Padding(
            padding: EdgeInsets.only(right: 4.0),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              child: Container(
                padding: EdgeInsets.all(10.0),
//            constraints: BoxConstraints.tightFor(),
//            height: 120.0,
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(weaCondition.weekDay,
                        style: weaCondition.weekDay == "星期日"
                            ? TextStyle(
                                color: Colors.red[300],
                                fontWeight: FontWeight.bold)
                            : weaCondition.weekDay == "星期六"
                                ? TextStyle(
                                    color: Colors.blue[500],
                                    fontWeight: FontWeight.bold)
                                : null),
                    Text(weaCondition.date),
                    SvgPicture.network(
                      weaCondition.img,
                      semanticsLabel: weaCondition.statusTxt,
                      placeholderBuilder: (BuildContext context) => Container(
                          padding: const EdgeInsets.all(30.0),
                          child: const CircularProgressIndicator()),
                    ),
                    Text(weaCondition.statusTxt),
                    Text(weaCondition.tem),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
