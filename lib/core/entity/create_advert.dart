import 'date_range.dart';
import 'location.dart';

class CreateAdvert {
  const CreateAdvert({
    this.title,
    this.price,
    this.description,
    this.category,
    this.owner,
    this.photos,
    this.availability,
    this.location
  });

  final String title;
  final double price;
  final String description;
  final String category;
  final String owner;
  final List<String> photos;
  final List<DateRange> availability;
  final Location location;

  Map<String,dynamic> toJson() => {
    'title' : title,
    'price' : price,
    'description' : description,
    'category' : category,
    'owner' : owner,
    'availability' : availability,
    'photos': photos,
    'location' : location
  };
}