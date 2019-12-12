import 'package:flutter_app/Fetch.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/physics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/orientGrid.dart';
import 'package:flutter_app/JoAnim.dart';

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

class Joapp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Jo extreme"),
      ),
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
                Fetch.handleData();
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
      body: OrientGrid(),
//        body: JoAnim(),
    );
  }



}
