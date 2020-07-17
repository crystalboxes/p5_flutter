class TimeDate {
  factory TimeDate._() => null;

  day() => DateTime.now().day;
  hour() => DateTime.now().hour;
  millis() => DateTime.now().millisecond;
  minute() => DateTime.now().minute;
  month() => DateTime.now().month;
  second() => DateTime.now().second;
  year() => DateTime.now().year;
}
