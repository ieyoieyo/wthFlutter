class WeaCondition {
  String date;
  String weekDay;
  bool isHoliday;
  String tem;
  String statusTxt;
  String img;

  WeaCondition(
      {this.date,
      this.weekDay,
      this.isHoliday = false,
      this.tem,
      this.statusTxt,
      this.img});

  @override
  String toString() {
    return "$date, $weekDay, $isHoliday, $tem, $statusTxt, $img";
  }
}
