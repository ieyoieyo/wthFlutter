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
      body: Stack(
        children: _getChildren(context),
      ),
    );
  }

  List<Widget> _getChildren(BuildContext context) {
    TextStyle textStyle = TextStyle(
      color: Colors.white,
      fontSize: Theme.of(context).textTheme.title.fontSize,
    );

    List<Widget> list = <Widget>[
//      Container(
//        decoration: BoxDecoration(
//          image: DecorationImage(
//            fit: BoxFit.fitHeight,
//            image: AssetImage("assets/images/head.png"),
//          ),
//        ),
//      ),
      Container(
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
      Positioned(
        top: 54.0,
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
      Positioned(
        top: 95.0,
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
      Positioned(
        top: 340.0,
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
            tag: wea36hr.timeRange,
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
      Positioned(
        top: 320.0,
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
