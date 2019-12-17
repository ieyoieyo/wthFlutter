class Wea36Hr {
  String timeRange;
  String type;
  String tem;
  String rain;
  String img;
  String statusTxt;

  Wea36Hr(
      {this.timeRange,
      this.type,
      this.tem,
      this.rain,
      this.img,
      this.statusTxt});

  String show() {
    return "$timeRange, $tem, $statusTxt, $rain, $img";
  }
}
