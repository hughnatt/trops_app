import 'dart:convert';
import 'package:http/http.dart' as Http;
import 'package:trops_app/api/constants.dart';
import 'package:trops_app/api/category.dart';
import 'package:trops_app/models/Advert.dart';
import 'package:trops_app/models/Location.dart';
import 'package:trops_app/models/DateRange.dart';

const String _dataBaseURI = "trops.sauton.xyz";

class SearchBody{
  String text;
  int priceMin;
  int priceMax;
  List<String> categories;
  List<double> location;
  int distance;

  SearchBody(this.text,this.priceMin,this.priceMax,this.categories, this.location, this.distance);

  Map<String,dynamic> toJson() => {
    'text': text,
    'priceMin': priceMin,
    'priceMax': priceMax,
    'categories': categories,
    'location': location,
    'distance': distance*1000
  };
}

Future<List<Advert>> getResults(String text, int priceMin, int priceMax, List<String> categories, List<double> location, int distance) async {

  SearchBody body = new SearchBody(text, priceMin, priceMax, categories, location, distance);

  var uri = new Uri.https(apiBaseURI, "/search");
  var response = await Http.post(uri, headers: {"Content-Type": "application/json"}, body: jsonEncode(body));

  if(response.statusCode == 200) {
    var result = await jsonDecode(response.body);

    List<Advert> _adverts = new List<Advert>();

    for (var item in result){
      List<String> photos = new List<String>.from(item['photos']);

      //Resolve category name
      String categoryName = getCategoryNameByID(item['category']);

      List<double> coordinates = List<double>.from(item['location']['coordinates']);

      Location location = Location(item['location']['label'],item['location']['city'],item['location']['postcode'],coordinates);

      List<DateRange> availability = List<DateRange>();

      List temp = List.from(item["availability"]);
      temp.forEach((item){
        availability.add(makeDateRange(item));
      });

      var advert = new Advert(
          item['_id'],
          item['title'],
          item['price'].toDouble(),
          item['description'],
          photos,
          item['owner'],
          categoryName,
          availability,
          location
      );

      _adverts.add(advert);
    }

    return _adverts;
  } else {
    throw Exception("Failed to get adverts");
  }
}

DateRange makeDateRange(Map<String,dynamic> fromJSON){
  return DateRange(DateTime.parse(fromJSON["start"]),DateTime.parse(fromJSON["end"]));
}