class Wea36Hr {
  String timeRange;
  String type;
  String tem;
  String rain;
  String img;
  String imgTxt;
  String statusTxt;
  String dayTxt;

  Wea36Hr(
      {this.timeRange,
      this.type,
      this.tem,
      this.rain,
      this.img,
      this.imgTxt,
      this.statusTxt}) {
    switch (type) {
      case "TD":
        dayTxt = "今日白天";
        break;
      case "TN":
        dayTxt = "今晚明晨";
        break;
      case "TM":
        dayTxt = "明日白天";
        break;
      case "TMN":
        dayTxt = "明日晚上";
        break;
    }

  }

  @override
  String toString() {
    return "$dayTxt, $timeRange, $tem, $statusTxt, $rain, $imgTxt, $img";
  }
}
