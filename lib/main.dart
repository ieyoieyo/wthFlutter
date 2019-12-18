import 'package:flutter_app/Fetch.dart';
import 'package:flutter_app/Wea36Hr.dart';
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

  Future<Map> _future;
  double imgIconSize36hr = 80.0;
  double imgIconSize = 50.0;

  double list36hrHeight = 206.0;
  double listWeekHeight = 270.0;

  double item36hrWidth = 110.0;
  double itemWeekWidth = 100.0;

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
      body: FutureBuilder<Map>(
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
    Map mmap = snapshot.data;
    double _titleSize = Theme.of(context).textTheme.title.fontSize;
    TextStyle _ts =
        TextStyle(fontSize: _titleSize, fontWeight: FontWeight.bold);
    TextStyle ts36hr = TextStyle(
      color: Colors.white,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(right: 10.0),
          alignment: Alignment.centerRight,
          transform: Matrix4.rotationZ(0.025),
          child: Text(
            Fetch.updateTime,
            style: TextStyle(
                fontSize: Theme.of(context).textTheme.body1.fontSize - 2.0),
          ),
        ),
        Container(
          alignment: Alignment.center,
          transform: Matrix4.rotationZ(0.025),
          margin: EdgeInsets.only(
            left: 8.0,
            bottom: 8.0,
          ),
          height: list36hrHeight,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: mmap["36hr"].length,
            itemBuilder: (context, index) {
              Wea36Hr wea36hr = mmap["36hr"].elementAt(index);
              return Padding(
                padding: EdgeInsets.only(right: 3.0),
                child: Container(
                  constraints: BoxConstraints.tightFor(
                    width: item36hrWidth,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    border: Border.all(
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        wea36hr.dayTxt,
                        style: ts36hr.copyWith(
                          fontSize: _titleSize,
                        ),
                      ),
                      SizedBox(
                        width: imgIconSize36hr,
                        height: imgIconSize36hr,
                        child: SvgPicture.network(
                          wea36hr.img,
                          semanticsLabel: wea36hr.statusTxt,
                          placeholderBuilder: (BuildContext context) =>
                              Container(
                                  padding: const EdgeInsets.all(30.0),
                                  child: const CircularProgressIndicator()),
                        ),
                      ),
                      Text(
                        wea36hr.imgTxt,
                        maxLines: 1,
                        softWrap: false,
                        style: ts36hr,
                      ),
                      Text(
                        wea36hr.tem,
                        style: ts36hr.copyWith(
                          fontSize: _titleSize,
                        ),
                      ),
                      Row(mainAxisSize: MainAxisSize.min, children: [
                        Padding(
                          padding: EdgeInsets.only(right: 2.0),
                          child: Icon(
                            Icons.beach_access,
                            color: Colors.white,
                            size: 12.0,
                          ),
                        ),
                        Text(
                          wea36hr.rain,
                          style: ts36hr,
                        ),
                      ]),
                      Text(
                        wea36hr.statusTxt,
                        textAlign: TextAlign.center,
                        style: ts36hr,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 10.0),
          transform: Matrix4.rotationZ(-0.05),
          child: Text(
            "未來一週",
            textScaleFactor: 1.1,
          ),
        ),
        Container(
          transform: Matrix4.rotationZ(-0.05),
          margin: EdgeInsets.all(8.0),
          height: listWeekHeight,
          child: ListView.builder(
            padding: EdgeInsets.only(right: 10.0),
            scrollDirection: Axis.horizontal,
            itemCount: mmap["week"].length,
            itemBuilder: (context, index) {
              WeaCondition weaCondition = mmap["week"].elementAt(index);
              return Padding(
                padding: EdgeInsets.only(right: 4.0),
                child: Container(
                  constraints: BoxConstraints.tightFor(
                    width: itemWeekWidth,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.all(8.0),
                  child: Column(
//                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(weaCondition.weekDay,
                          style: weaCondition.weekDay == "星期日"
                              ? _ts.copyWith(
                                  color: Colors.red,
                                )
                              : weaCondition.weekDay == "星期六"
                                  ? _ts.copyWith(
                                      color: Colors.blue[500],
                                    )
                                  : _ts.copyWith(
                                      fontWeight: FontWeight.normal)),
                      SizedBox(
                        height: 6.0,
                      ),
                      Text(weaCondition.date),
                      SizedBox(
                        width: imgIconSize,
                        height: imgIconSize,
                        child: SvgPicture.network(
                          weaCondition.img,
                          semanticsLabel: weaCondition.statusTxt,
                          placeholderBuilder: (BuildContext context) =>
                              Container(
                                  padding: const EdgeInsets.all(2.0),
                                  child: const CircularProgressIndicator()),
                        ),
                      ),
                      Text(weaCondition.statusTxt),
                      Text(
                        weaCondition.tem,
                        style: TextStyle(fontSize: _titleSize),
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      SizedBox(
                        width: imgIconSize,
                        height: imgIconSize,
                        child: SvgPicture.network(
                          weaCondition.imgNight,
                          semanticsLabel: weaCondition.statusTxtNight,
                          placeholderBuilder: (BuildContext context) =>
                              Container(
                                  padding: const EdgeInsets.all(30.0),
                                  child: const CircularProgressIndicator()),
                        ),
                      ),
                      Text(weaCondition.statusTxtNight),
                      Text(
                        weaCondition.temNight,
                        style: TextStyle(fontSize: _titleSize),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
