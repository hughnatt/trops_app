import 'package:trops_app/core/entity/date_range.dart';

class DateRangeMapper {
  DateRange map(Map<String,dynamic> json) {
    return DateRange(DateTime.parse(json["start"]),DateTime.parse(json["end"]));
  }
}