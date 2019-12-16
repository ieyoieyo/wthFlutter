class WeaCondition {
  String date;
  String weekDay;
  bool isHoliday;
  String tem;
  String temNight;
  String statusTxt;
  String statusTxtNight;
  String img;
  String imgNight;

  WeaCondition(
      {this.date,
      this.weekDay,
      this.isHoliday,
      this.tem,
      this.temNight,
      this.statusTxt,
      this.statusTxtNight,
      this.img,
      this.imgNight});

  @override
  String toString() {
    return "$date, $weekDay, $isHoliday, $tem, $statusTxt, $img, Night > $temNight, $statusTxtNight, $imgNight";
  }
}
