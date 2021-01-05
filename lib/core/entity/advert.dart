import 'date_range.dart';
import 'location.dart';

class Advert {
  String id;
  String title;
  double price;
  String description;
  List<String> photos;
  String owner;
  String category;
  List<DateRange> availability;
  Location location;

  Advert({
    this.id,
    this.title,
    this.price,
    this.description,
    this.photos,
    this.owner,
    this.category,
    this.availability,
    this.location
  });
}