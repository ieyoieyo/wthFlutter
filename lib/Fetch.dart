import 'package:http/http.dart' as http;
import 'package:flutter/physics.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';


class Fetch {

  static void handleData() async{
    String result = await fetchPost();
    Document document = parse(result);
    var aa = document.querySelector('ul#36HR_MOD');
    print(aa);
  }

  static Future<String> fetchPost() async {
//    await Future.delayed(Duration(seconds: 3));
    String url = "https://www.cwb.gov.tw/V8/C/W/County/County.html?CID=63";
    final response = await http.get(url);

    if (response.statusCode == 200) {
//      return Post.fromJson(json.decode(response.body));
      return response.body;
    } else {
      throw Exception('Failed to load post');
    }
  }



}
