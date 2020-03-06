import 'dart:convert';
import 'package:http/http.dart' as Http;
import 'package:trops_app/api/api.dart';
import 'package:trops_app/api/category.dart';
import 'package:trops_app/models/Advert.dart';
import 'package:trops_app/models/DateRange.dart';
import 'package:trops_app/models/Location.dart';

Future<List<Advert>> getAllAdverts() async {

  List<Advert> _adverts = new List<Advert>();
  var uri = new Uri.https(apiBaseURI, "/advert");
  var response = await Http.get(uri, headers: {"Content-Type": "application/json"});

  if(response.statusCode == 200) {

    var result = await jsonDecode(response.body);
    result.forEach((item) async {

      List<String> photos = new List<String>.from(item["photos"]);

      //Resolve category name
      String categoryName = getCategoryNameByID(item['category']);

      var advert = new Advert(
        item["_id"],
        item["title"],
        item["price"].toDouble(),
        item["description"],
        photos,
        item["owner"],
        categoryName
      );

      _adverts.add(advert);

    });

    return _adverts;

  }
  else {
    throw Exception("Failed to get adverts");
  }
}

class CreateAdvertBody{
  String title;
  double price;
  String description;
  String category;
  String owner;
  List<String> photos;
  List<DateRange> availability;
  Location location;

  CreateAdvertBody(this.title,this.price,this.description,this.category,this.owner,this.photos,this.availability,this.location);

  Map<String,dynamic> toJson() => {
    'title' : title,
    'price' : price,
    'description' : description,
    'category' : category,
    'owner' : owner,
    'availability' : availability,
    'photos': photos,
    'location' : location.getRelativePosition()
  };
}

Future<Http.Response> uploadAdvertApi(String token,String title, double price, String description,String category,String owner,List<String> photos, List<DateRange> availability, Location location) async {
  CreateAdvertBody body = CreateAdvertBody(title, price, description, category, owner, photos, availability, location);
  Uri uri = new Uri.https(apiBaseURI, "/advert");
  Http.Response response = await Http.post(uri,headers: {"Authorization" : "Bearer $token","Content-Type": "application/json"},body : jsonEncode(body));
  print(response.statusCode);
  print(response.body);
  return response;

}

Future<List<Advert>> getAdvertOfUser(String owner, String token) async {
  List<Advert> _adverts = new List<Advert>();
  var jsonBody = '''
  {
    "owner": "$owner"
  }''';
  var uri = new Uri.https(apiBaseURI, "/advert/owner");
  print(jsonBody);
  var response = await Http.post(uri,headers: {"Authorization" : "Bearer $token", "Content-Type": "application/json"},body : jsonBody);
  print(response.statusCode);
  print(response.body);

  if(response.statusCode == 200) {
    var result = await jsonDecode(response.body);
    result.forEach((item) {
      List<String> photos = new List<String>.from(item["photos"]);

      var advert = new Advert(
          item["_id"],
          item["title"],
          item["price"].toDouble(),
          item["description"],
          photos,
          item["owner"],
          item["category"]
      );

      _adverts.add(advert);
    });
    return _adverts;
  } else {
    throw Exception("Failed to get adverts");
  }

}