import 'package:flutter/material.dart';

import 'Constant.dart';

class JoDropdownButton extends StatefulWidget {
  final String county;
  final ValueChanged<List<String>> onCountyChange;

  JoDropdownButton({@required this.county, @required this.onCountyChange});

  @override
  _JoDropdownButtonState createState() => _JoDropdownButtonState();
}

class _JoDropdownButtonState extends State<JoDropdownButton> {

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: widget.county,
      elevation: 16,
      iconSize: 32,
      underline: Container(
        height: 2.0,
        color: Colors.deepPurpleAccent.withAlpha(100),
      ),
      onChanged: (String newValue) {
        onCountyChange(newValue);
      },
//      selectedItemBuilder: (BuildContext context) {
//        return Constant.county.values.map((String value) {
//          return Text(
//            countyNumber,
//            style: TextStyle(color: Colors.lightBlue),
//          );
//        }).toList();
//      },
      items:
          Constant.county.values.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            textAlign: TextAlign.right,
            textScaleFactor: 1.1,
          ),
        );
      }).toList(),
    );
  }

  void onCountyChange(String newValue) {
    String num;
    Constant.county.forEach((key, value){
      if (value == newValue) {
        num = key;
      }
    });

//    setState(() {
//      widget.county = newValue;
//    });

    widget.onCountyChange([num, newValue]);
  }
}
