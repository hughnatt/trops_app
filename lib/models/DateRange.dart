

class DateRange{
  DateRange(this.start,this.end);
  DateTime start;
  DateTime end;

  Map<String,dynamic> toJson() => {
    'start' : start.toIso8601String(),
    'end' : end.toIso8601String(),
  };
}