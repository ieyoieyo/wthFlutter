import 'dart:convert';
import 'package:flutter_app/WeaCondition.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import "package:universal_html/html.dart" as uhtml;

class Fetch {
  static Future<List<WeaCondition>> handleData(GlobalKey<ScaffoldState> scaffoldkey) async {
    String result = await fetchPost();
    uhtml.Document document =
        uhtml.DomParser().parseFromString(result, "text/html");
    var element = document.querySelector("span.signal img");
    String title = element.getAttribute("title");

//    print(element.outerHtml);
//    scaffoldkey.currentState.showSnackBar(SnackBar(
//      content: Text(title),
//    ));
    return gg(document);
  }

  static List<WeaCondition> gg(uhtml.Document document) {
    List<WeaCondition> list = [];
    RegExp htmlTag = RegExp("<[^>]*>");
    RegExp notSpace = RegExp(r'\S+');

    for (int i = 1; i < 8; i++) {
      WeaCondition weaCondition = WeaCondition();
      uhtml.Element thElement = document.querySelector("th#day$i");
      if (thElement.toString().contains("holiday")) {
        weaCondition.isHoliday = true;
      }
      //刪掉 HTML TAGS
      String ss = thElement.outerHtml.replaceAll(htmlTag, "");

      int count = 1;
      for (var match in notSpace.allMatches(ss)) {
        if (count == 1) weaCondition.weekDay = match.group(0);
        else weaCondition.date = match.group(0);
        count ++;
      }

      uhtml.Element imgElement = document.querySelector("tr.day td[headers='day$i'] img");
      weaCondition.img = "https://www.cwb.gov.tw" + imgElement.getAttribute("src");
      weaCondition.statusTxt = imgElement.getAttribute("title");

      uhtml.Element imgNightElement = document.querySelector("tr.night td[headers='day$i'] img");
      weaCondition.imgNight = "https://www.cwb.gov.tw" + imgNightElement.getAttribute("src");
      weaCondition.statusTxtNight = imgNightElement.getAttribute("title");

      uhtml.Element temElement = document.querySelector("tr.day td[headers='day$i'] p span");
      weaCondition.tem = temElement.outerHtml.replaceAll(htmlTag, "");

      uhtml.Element temNightElement = document.querySelector("tr.night td[headers='day$i'] p span");
      weaCondition.temNight = temNightElement.outerHtml.replaceAll(htmlTag, "");

      print(weaCondition.toString());
      list.add(weaCondition);
    }
    return list;
  }

  static Future<String> fetchPost() async {
//    await Future.delayed(Duration(seconds: 3));
    String url =
        "https://www.cwb.gov.tw/V8/C/W/County/MOD/Week/63_Week_PC.html";
//    String url = "https://www.cwb.gov.tw/V8/C/W/County/County.html?CID=63";
    final response = await http.get(url);

    if (response.statusCode == 200) {
//      return Post.fromJson(json.decode(response.body));
      var decoder = Utf8Decoder();
      return decoder.convert(response.bodyBytes);
    } else {
      throw Exception('Failed to load post');
    }
  }
}
