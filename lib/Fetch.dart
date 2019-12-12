import 'package:http/http.dart' as http;
import 'package:flutter/physics.dart';
import 'package:flutter/material.dart';

class Fetch {

  static void handleData() async{
    String result = await fetchPost();
    print(result);
  }

  static Future<String> fetchPost() async {
    await Future.delayed(Duration(seconds: 3));
    String url = "https://dart.dev/codelabs/async-await";
    final response = await http.get(url);

    if (response.statusCode == 200) {
//      return Post.fromJson(json.decode(response.body));
      return response.body;
    } else {
      throw Exception('Failed to load post');
    }
  }



}
