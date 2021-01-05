import 'package:flutter/foundation.dart';
import 'package:trops_app/core/data/category_repository.dart';
import 'package:trops_app/core/entity/advert.dart';
import 'package:trops_app/core/entity/date_range.dart';
import 'package:trops_app/core/entity/location.dart';
import 'date_range_mapper.dart';

class AdvertMapper {

  final CategoryRepository categoryRepository;

  const AdvertMapper({@required this.categoryRepository});

  Advert map(dynamic jsonAdvert) {
    List<String> photos = new List<String>.from(jsonAdvert["photos"]);
    String categoryName = categoryRepository.getCategoryNameByID(jsonAdvert['category']);
    List<double> coordinates = List<double>.from(
        jsonAdvert['location']['coordinates']);
    Location location = Location(
        jsonAdvert['location']['label'], jsonAdvert['location']['city'],
        jsonAdvert['location']['postcode'], coordinates);
    List<DateRange> availability = List<DateRange>();
    List temp = List.from(jsonAdvert["availability"]);
    temp.forEach((item) {
      availability.add(DateRangeMapper().map(item));
    });

    return Advert(
      id: jsonAdvert["_id"],
      title: jsonAdvert["title"],
      price: jsonAdvert["price"].toDouble(),
      description: jsonAdvert["description"],
      photos: photos,
      owner: jsonAdvert["owner"],
      category: categoryName,
      availability: availability,
      location: location,
    );
  }
}

class AdvertListMapper {

  final CategoryRepository categoryRepository;

  const AdvertListMapper({ @required this.categoryRepository });

  List<Advert> map(dynamic json) {
    List<Advert> adverts = List<Advert>();
    for (var item in json){
      adverts.add(AdvertMapper(categoryRepository: categoryRepository).map(item));
    }
    return adverts;
  }
}