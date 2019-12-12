import 'package:flutter/physics.dart';
import 'package:flutter/material.dart';


class JoAnim extends StatefulWidget {
  @override
  _JoAnimState createState() => _JoAnimState();
}

class _JoAnimState extends State<JoAnim> {
  double _hight = 128;
  int _alpha = 100;
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          RaisedButton(
            onPressed: () {
              final SnackBar snackBar = SnackBar(
                content: Text("Yo, man, Snack is it = $counter"),
                action: SnackBarAction(
                  label: "Undo",
                  onPressed: () {},
                ),
              );
              Scaffold.of(context).showSnackBar(snackBar);
              counter ++ ;

              setState(() {
                if (_hight > 300) {
                  _hight = 100;
                } else
                  _hight += 10;

                _alpha = _alpha == 0 ? 100 : 0;
              });
            },
          ),
          AnimatedContainer(
            child: FlutterLogo(
              size: _hight,
            ),
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOutBack,
            decoration: BoxDecoration(color: Color.fromARGB(_alpha, 0, 0, 0)),
          ),
        ],
      ),
    );
  }
}
