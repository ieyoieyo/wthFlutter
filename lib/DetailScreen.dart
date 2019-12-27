import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simple_animations/simple_animations.dart';

class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    timeDilation = 5.0; // 1.0 means normal animation speed.
    return Scaffold(
      appBar: AppBar(
        title: Text("2222"),
      ),
      body: Container(
        alignment: Alignment.center,
        child: ControlledAnimation(
          tween: Matrix4Tween(
            begin: Matrix4.rotationZ(-6.0),
            end: Matrix4.rotationZ(6.0),
          ),
          duration: Duration(milliseconds: 350),
          playback: Playback.MIRROR,
          builder: (context, transform) => Hero(
            tag: 0,
            child: Transform(
              alignment: Alignment.center,
              transform: transform,
              child: SizedBox(
                width: 200.0,
                height: 200.0,
                child: SvgPicture.network(
                  "https://www.cwb.gov.tw/V8/assets/img/weather_icons/weathers/svg_icon/day/07.svg",
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
    );
  }
}
