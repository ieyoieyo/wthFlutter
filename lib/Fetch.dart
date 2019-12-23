import 'dart:convert';
import 'package:flutter_app/Wea36Hr.dart';
import 'package:flutter_app/WeaCondition.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import "package:universal_html/html.dart" as uhtml;

class Fetch {
  static String updateTime = "";

  static Future<Map> handleData(String countyNum) async {
    Map mmap = {};
    String url36hr =
        "https://www.cwb.gov.tw/Data/js/TableData_36hr_County_C.js";
    String result36hr = await fetchPost(url36hr);
    mmap["36hr"] = parse36(result36hr, countyNum);

    String urlWeek =
        "https://www.cwb.gov.tw/V8/C/W/County/MOD/Week/$countyNum"+"_Week_PC.html";
    String result = await fetchPost(urlWeek);
    uhtml.Document document =
        uhtml.DomParser().parseFromString(result, "text/html");

//    scaffoldkey.currentState.showSnackBar(SnackBar(
//      content: Text(title),
//    ));
    mmap["week"] = parseWeek(document);
//    print(mmap);
    return mmap;
//    return gg(document);
  }

  static List<Wea36Hr> parse36(String response, String countyNum) {
    updateTime = RegExp("\=.+;").stringMatch(response);
    updateTime = RegExp("\\d+.+\\d").stringMatch(updateTime);
    updateTime = "資料更新時間：" + updateTime;

    List<Wea36Hr> allList = [];
    String mapStr = RegExp(r"""\{[\n\w\d\s'":\[\]\{\}\/\-\~,\u4E00-\u9FA5]+""")
        .stringMatch(response);
    mapStr = mapStr.replaceAll("'", "\"");
    String svgRoot =
        "https://www.cwb.gov.tw/V8/assets/img/weather_icons/weathers/svg_icon/";
    var joMap = jsonDecode(mapStr);
    var joo = joMap[countyNum];
    for (int i = 0; i < 3; i++) {
      String svg = svgRoot;
      if (joo[i]["Type"].toString().endsWith("M") ||
          joo[i]["Type"].toString().endsWith("D")) {
        svg += "day/";
      } else if (joo[i]["Type"].toString().endsWith("N")) svg += "night/";
      svg += joo[i]["Wx_Icon"] + ".svg";

      Wea36Hr wea36hr = Wea36Hr(
        timeRange: joo[i]["TimeRange"],
        img: svg,
        imgTxt: joo[i]["Wx"],
        type: joo[i]["Type"],
        tem: joo[i]["Temp"]["C"]["L"] + " - " + joo[i]["Temp"]["C"]["H"],
        rain: joo[i]["PoP"],
        statusTxt: joo[i]["CI"],
      );
      print(wea36hr.show());
      allList.add(wea36hr);
    }
    return allList;
  }

  static List<WeaCondition> parseWeek(uhtml.Document document) {
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
        if (count == 1)
          weaCondition.weekDay = match.group(0);
        else
          weaCondition.date = match.group(0);
        count++;
      }

      uhtml.Element imgElement =
          document.querySelector("tr.day td[headers='day$i'] img");
      weaCondition.img =
          "https://www.cwb.gov.tw" + imgElement.getAttribute("src");
      weaCondition.statusTxt = imgElement.getAttribute("title");

      uhtml.Element imgNightElement =
          document.querySelector("tr.night td[headers='day$i'] img");
      weaCondition.imgNight =
          "https://www.cwb.gov.tw" + imgNightElement.getAttribute("src");
      weaCondition.statusTxtNight = imgNightElement.getAttribute("title");

      uhtml.Element temElement =
          document.querySelector("tr.day td[headers='day$i'] p span");
      weaCondition.tem = temElement.outerHtml.replaceAll(htmlTag, "");

      uhtml.Element temNightElement =
          document.querySelector("tr.night td[headers='day$i'] p span");
      weaCondition.temNight = temNightElement.outerHtml.replaceAll(htmlTag, "");

//      print(weaCondition.toString());
      list.add(weaCondition);
    }
    return list;
  }

  static Future<String> fetchPost(String url) async {
//    await Future.delayed(Duration(seconds: 3));
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
