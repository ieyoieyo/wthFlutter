import 'package:flutter/material.dart';

class OrientGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return GridView.count(
        crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
        children: List.generate(100, (index) {
          return Center(
            child: Text(
              "Itttjo $index",
              style: Theme.of(context).textTheme.headline,
            ),
          );
        }),
      );
    });
  }
}
