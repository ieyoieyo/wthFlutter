import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_app/Wea36Hr.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simple_animations/simple_animations.dart';

import 'Fetch.dart';

class DetailScreen extends StatelessWidget {
  final String county;
  final Wea36Hr wea36hr;

  DetailScreen({@required this.county, @required this.wea36hr});

  @override
  Widget build(BuildContext context) {
//    timeDilation = 5.0; // 1.0 means normal animation speed.
    return Scaffold(
      appBar: AppBar(
        title: Text("$county  ${wea36hr.dayTxt}"),
      ),
      backgroundColor: Colors.white24,
      body: ListView(
        children: _getListViewChildren(context),
      ),
    );
  }

  /// ListView裡的所有Item。第1個是一個Stack, 第2個開始是由List做出來的炫炫清單
  List<Widget> _getListViewChildren(BuildContext context) {
    List<Widget> list = [Stack(children: _getStackChildren(context))];

    var ts = TextStyle(
      height: 1.1,
      fontSize: 18.0,
      color: Colors.white,
    );
    List<Color> colors = [
      Colors.blue,
      Colors.pink[300],
      Colors.purple[600],
      Colors.black,
      Colors.green[600],
      Colors.indigo[700],
      Colors.amber[900],
      Colors.blue,
    ];
    //炫炫清單
    for (int i = 0; i < Fetch.warnList.length; i++) {
      list.add(Container(
        //下一個的主色，這一個的底色
        color: i != Fetch.warnList.length - 1 ? colors[i + 1] : Colors.blue,
        child: Container(
          decoration: BoxDecoration(
              //這一個的主色。夜晚的話，第一個為黑色
              color: (i == 0 && wea36hr.type != "TD" && wea36hr.type != "TM")
                  ? Colors.black
                  : colors[i],
              borderRadius:
                  BorderRadius.only(bottomLeft: Radius.circular(80.0))),
          child: Container(
            padding: EdgeInsets.only(
                left: 50.0, top: 20.0, right: 10.0, bottom: 20.0),
            child: Text(Fetch.warnList[i], style: ts),
          ),
        ),
      ));
    }
    return list;
  }

  List<Widget> _getStackChildren(BuildContext context) {
    TextStyle textStyle = TextStyle(
      color: Colors.white,
      fontSize: Theme.of(context).textTheme.title.fontSize,
    );

    var txtDuration = Duration(seconds: 1);

    List<Widget> list = <Widget>[
//      Container(
//        decoration: BoxDecoration(
//          image: DecorationImage(
//            fit: BoxFit.fitHeight,
//            image: AssetImage("assets/images/head.png"),
//          ),
//        ),
//      ),
      // Stack的底圖
      Container(
        height: 440.0,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topLeft,
            radius: 1.1,
            colors: (wea36hr.type == "TD" || wea36hr.type == "TM")
                ? [
                    Colors.blue[50],
                    Colors.blue[100],
                    Colors.blue,
                  ]
                : [
                    Colors.white70,
                    Colors.black,
                  ],
          ),
        ),
      ),
      //county：台北市
      Positioned(
        right: -10.0,
        top: -6.0,
        child: Card(
          color: Colors.green[300],
//          margin: EdgeInsets.only(top: 6.0),
          elevation: 10.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0),
              bottomLeft: Radius.circular(10.0),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              county,
              style: textStyle,
            ),
          ),
        ),
      ),
      //timeRange: 時間範圍 幾月幾號幾點到幾點
      Positioned(
        top: 20.0,
        left: -10.0,
        child: Card(
            color: Colors.blue[300],
            elevation: 10.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              topRight: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0),
            )),
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                wea36hr.timeRange,
                style: textStyle,
              ),
            )),
      ),
      //imgTxt:陰短暫雨
      ControlledAnimation(
        playback: Playback.MIRROR,
        duration: txtDuration,
        tween: Tween(begin: 54.0, end: 44.0),
        builder: (context, top) => Positioned(
          top: top,
          right: -10.0,
          child: Card(
              color: Colors.orange[300],
//            margin: EdgeInsets.only(top: 6.0),
              elevation: 10.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                bottomLeft: Radius.circular(10.0),
              )),
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  wea36hr.imgTxt,
                  textScaleFactor: 1.6,
                  style: textStyle,
                ),
              )),
        ),
      ),
      //tem:氣溫
      ControlledAnimation(
        startPosition: .7,
        playback: Playback.MIRROR,
        duration: Duration(milliseconds: 1600),
        tween: Tween(begin: 95.0, end: 75.0),
        builder: (context, top) => Positioned(
          top: top,
          left: -10.0,
          child: Card(
              color: Colors.green[300],
              elevation: 10.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                topRight: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
              )),
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "${wea36hr.tem} °C",
                  textScaleFactor: 2.2,
                  style: textStyle,
                ),
              )),
        ),
      ),
      //warnTitle: 幾句話Warn的標題
      ControlledAnimation(
        startPosition: 1.0,
        playback: Playback.MIRROR,
        duration: txtDuration,
        tween: Tween(begin: 340.0, end: 330.0),
        builder: (context, top) => Positioned(
          top: top,
          left: -10.0,
          child: Card(
            color: Colors.orange[300],
            elevation: 10.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              topRight: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0),
            )),
            child: SizedBox(
              width: 320.0,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  Fetch.warnTitle,
//                maxLines: 5,
                  style: textStyle.copyWith(height: 1.5),
                ),
              ),
            ),
          ),
        ),
      ),
      //圖片，也是Hero
      Positioned(
        top: 140.0,
        left: 50.0,
        right: 50.0,
        child: ControlledAnimation(
          tween: Matrix4Tween(
            begin: Matrix4.rotationZ(-6.0),
            end: Matrix4.rotationZ(6.0),
          ),
          duration: Duration(milliseconds: 350),
          playback: Playback.MIRROR,
          builder: (context, transform) => Hero(
            tag: wea36hr.timeRange, //用這當 Tag應可避免重複
            child: Transform(
              alignment: Alignment.center,
              transform: transform,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: SizedBox(
                  width: 200.0,
                  height: 200.0,
                  child: SvgPicture.network(
                    wea36hr.img,
//                  semanticsLabel: wea36hr.statusTxt,
                    placeholderBuilder: (BuildContext context) => Container(
                        padding: const EdgeInsets.all(30.0),
                        child: const CircularProgressIndicator()),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      //降雨機率 一個Row裡一個Icon和一個Text
      Positioned(
        top: 180.0,
        right: 50.0,
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: EdgeInsets.only(right: 5.0),
            child: Icon(
              Icons.beach_access,
              color: Colors.white,
              size: 32.0,
            ),
          ),
          Text(
            "${wea36hr.rain} %",
            textScaleFactor: 1.2,
            style: textStyle,
          ),
        ]),
      ),
      //statusTxt: 寒冷至稍有寒意
      ControlledAnimation(
        startPosition: .2,
        playback: Playback.MIRROR,
        duration: txtDuration,
        tween: Tween(begin: 320.0, end: 300.0),
        builder: (context, top) => Positioned(
          top: top,
          right: -10.0,
          child: Card(
              color: Colors.grey,
              elevation: 10.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                bottomLeft: Radius.circular(10.0),
              )),
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  wea36hr.statusTxt,
                  style: textStyle,
                ),
              )),
        ),
      ),
    ];

//    Fetch.warnList.forEach((String str) {
//      list.add(
//        Container(
//          margin: EdgeInsets.all(20.0),
//          child: Text(str,
//              textScaleFactor: .9,
//              style: textStyle.copyWith(
//                letterSpacing: 3.0,
//                height: 1.5,
////                fontSize: Theme.of(context).textTheme.subhead.fontSize,
//              )),
//        ),
//      );
//    });

    return list;
  }
}
