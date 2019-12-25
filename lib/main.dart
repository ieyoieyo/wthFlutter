import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_app/Fetch.dart';
import 'package:flutter_app/JoDropdownButton.dart';
import 'package:flutter_app/Wea36Hr.dart';
import 'package:flutter_app/WeaCondition.dart';
import 'package:flutter_app/animEffect.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/physics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/orientGrid.dart';
import 'package:flutter_app/JoAnim.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'Constant.dart';

main() {
  runApp(MaterialApp(
    title: Constant.appName,
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
  String countyNum;
  String county;
  final String COUNTYNUM_KEY = "countyNum";
  final String COUNTY_KEY = "county";

  double imgIconSize36hr = 80.0;
  double imgIconSize = 50.0;

  double list36hrHeight = 206.0;
  double listWeekHeight = 270.0;

  double item36hrWidth = 110.0;
  double itemWeekWidth = 100.0;

  File headImageFile;

  @override
  _JoappState createState() => _JoappState();
}

class _JoappState extends State<Joapp> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  Future<Map> _future;

  @override
  void initState() {
    super.initState();

    _getStoredCounty().then((vo) {
//      setState(() {
        _setFutureFetchBuild();
//      });
    });

    //TODO: 只有首次開啟app才寫入
    _getImageFromAssetsAndWriteDisk().then((File file){
      setState(() {
        widget.headImageFile = file;
      });
    });
  }

  Future<File> _getImageFromAssetsAndWriteDisk() async {
    //讀取assets image為Bytes
    final byteData = await rootBundle.load('assets/images/head.jpg');
    //目的地File
    //TODO:加入Platform判斷
    final file = File('${(await getExternalStorageDirectory()).path}/head.jpg');
    //寫入Bytes至目的地File
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return file;
  }

  void _setFutureFetchBuild() {
    _future = Fetch.handleData(widget.countyNum);
  }

  Future<void> _getStoredCounty() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    widget.countyNum = prefs.getString(widget.COUNTYNUM_KEY) ?? "63";
    widget.county = prefs.getString(widget.COUNTY_KEY) ?? "臺北市";
  }

  Future<void> _saveCountyToDisk() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(widget.COUNTYNUM_KEY, widget.countyNum);
    prefs.setString(widget.COUNTY_KEY, widget.county);
  }

  void _handleCountyChange(List<String> selectCounty) {
    setState(() {
      widget.countyNum = selectCounty.elementAt(0);
      widget.county = selectCounty.elementAt(1);

      _setFutureFetchBuild();
    });

    Navigator.pop(context);

    _saveCountyToDisk();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: widget.county == null
            ? Text(Constant.appName + "\u{1f600}")
            : Text(Constant.appName + "\u{1f600}    " + widget.county),
      ),
      backgroundColor: Colors.lightBlue[200],
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            widget.headImageFile == null
                ? DrawerHeader(
                    child: Text("DRAWER HEADER"),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                  )
                : Image.file(widget.headImageFile),
//            DrawerHeader(
//              child: Text("DRAWER HEADER"),
//              decoration: BoxDecoration(
//                color: Colors.blue,
//              ),
//            ),
            ListTile(
              leading: Icon(Icons.location_city),
              title: JoDropdownButton(
                  county: widget.county, onCountyChange: _handleCountyChange),
//              onTap: () {
//                setState(() {
//                  _future = Fetch.handleData(_scaffoldkey);
//                });
//                Navigator.pop(context);
//              },
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
            _setFutureFetchBuild();
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
    Map dataMap = snapshot.data;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          //資料更新時間
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
          //限制 ListView(36hr) 的高度
          alignment: Alignment.center,
          transform: Matrix4.rotationZ(0.025),
          margin: EdgeInsets.only(
            left: 8.0,
            bottom: 8.0,
          ),
          height: widget.list36hrHeight,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: dataMap["36hr"].length,
            itemBuilder: (context, index) {
              Wea36Hr wea36hr = dataMap["36hr"].elementAt(index);
              return getItem36hr(index, wea36hr);
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
        JoFadeIn(
          delay: 2.0,
          isVertical: false,
          child: Container(
            //限制 ListView(week) 的高度
            transform: Matrix4.rotationZ(-0.05),
            margin: EdgeInsets.only(left: 8.0, right: 8.0, top: 2.0),
            height: widget.listWeekHeight,
            child: ListView.builder(
              padding: EdgeInsets.only(right: 10.0),
              scrollDirection: Axis.horizontal,
              itemCount: dataMap["week"].length,
              itemBuilder: (context, index) {
                WeaCondition weaCondition = dataMap["week"].elementAt(index);
                return getItemWeek(index, weaCondition);
              },
            ),
          ),
        )
      ],
    );
  }

  Widget getItem36hr(int index, Wea36Hr wea36hr) {
    double _titleSize = Theme.of(context).textTheme.title.fontSize;
    TextStyle ts36hr = TextStyle(
      color: Colors.white,
    );

    double delay = 0.0;
    switch (index) {
//      case 0:
//        delay = 0.1;
//        break;
      case 1:
        delay = 0.8;
        break;
      case 2:
        delay = 1.6;
        break;
    }

    return JoFadeIn(
      delay: delay,
      isVertical: true,
      child: Padding(
        padding: EdgeInsets.only(right: 3.0),
        child: ControlledAnimation(
          duration: Duration(seconds: 1),
          tween: AlignmentTween(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          curve: Curves.bounceOut,
          playback: Playback.MIRROR,
          builder: (context, alignment) => Container(
            constraints: BoxConstraints.tightFor(
              width: widget.item36hrWidth,
            ),
            decoration: BoxDecoration(
              color: Colors.black54,
              border: Border.all(
                color: Colors.black,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.all(8.0),
//                    padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Text(
                  wea36hr.dayTxt,
                  style: ts36hr.copyWith(
                    fontSize: _titleSize,
                  ),
                ),
                ControlledAnimation(
                  tween: Matrix4Tween(
                      begin: Matrix4.rotationZ(-6.0),
                      end: Matrix4.rotationZ(6.0)),
                  duration: Duration(milliseconds: 350),
                  playback: Playback.MIRROR,
//                          curve: Curves.bounceOut,
                  builder: (context, transform) => Transform(
                    alignment: Alignment.center,
                    transform: index == 0 ? transform : Matrix4.rotationZ(0.0),
                    child: SizedBox(
                      width: widget.imgIconSize36hr,
                      height: widget.imgIconSize36hr,
                      child: SvgPicture.network(
                        wea36hr.img,
                        semanticsLabel: wea36hr.statusTxt,
                        placeholderBuilder: (BuildContext context) => Container(
                            padding: const EdgeInsets.all(30.0),
                            child: const CircularProgressIndicator()),
                      ),
                    ),
                  ),
                ),
                Text(
                  wea36hr.imgTxt,
                  maxLines: 1,
                  softWrap: false,
                  style: ts36hr,
                ),
                Container(
                  alignment: index == 0 ? alignment : Alignment.center,
                  child: Text(
                    wea36hr.tem,
                    style: ts36hr.copyWith(
                      fontSize: _titleSize,
                    ),
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
        ),
      ),
    );
  }

  Widget getItemWeek(int index, WeaCondition weaCondition) {
    double _titleSize = Theme.of(context).textTheme.title.fontSize;
    TextStyle textStyle =
        TextStyle(fontSize: _titleSize, fontWeight: FontWeight.bold);
    return Padding(
      padding: EdgeInsets.only(right: 4.0),
      child: Container(
        constraints: BoxConstraints.tightFor(
          width: widget.itemWeekWidth,
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
                    ? textStyle.copyWith(
                        color: Colors.red,
                      )
                    : weaCondition.weekDay == "星期六"
                        ? textStyle.copyWith(
                            color: Colors.blue[500],
                          )
                        : textStyle.copyWith(fontWeight: FontWeight.normal)),
            SizedBox(
              height: 6.0,
            ),
            Text(weaCondition.date),
            SizedBox(
              width: widget.imgIconSize,
              height: widget.imgIconSize,
              child: SvgPicture.network(
                weaCondition.img,
                semanticsLabel: weaCondition.statusTxt,
                placeholderBuilder: (BuildContext context) => Container(
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
              width: widget.imgIconSize,
              height: widget.imgIconSize,
              child: SvgPicture.network(
                weaCondition.imgNight,
                semanticsLabel: weaCondition.statusTxtNight,
                placeholderBuilder: (BuildContext context) => Container(
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
  }
}
