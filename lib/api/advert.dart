import 'dart:convert';
import 'package:http/http.dart' as Http;
import 'package:trops_app/api/constants.dart';
import 'package:trops_app/api/category.dart';
import 'package:trops_app/models/Advert.dart';
import 'package:trops_app/models/DateRange.dart';
import 'package:trops_app/models/Location.dart';
import 'package:trops_app/models/User.dart';


enum AdvertUploadStatus {SUCCESS,FAILURE}

Future<List<Advert>> getAllAdverts()  async {
  return getAdvertsByUser(null);
}

Future<List<Advert>> getAdvertsByUser(User user) async {
  Uri uri;
  if (user == null){
    uri = Uri.https(apiBaseURI, '/advert');
  } else {
    uri = Uri.https(apiBaseURI, '/advert/owner/' + user.getId());
  }

  Http.Response response = await Http.get(uri, headers: {"Content-Type": "application/json"});

  List<Advert> _adverts = new List<Advert>();

  switch (response.statusCode){
    case 200:
      var jsonArray = await jsonDecode(response.body);
      jsonArray.forEach((item) {
        try {
          _adverts.add(decodeAdvert(item));
        } catch(error){}
      });
      break;
    default:
      break;
  }

  return _adverts;
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
    'location' : location
  };
}

Future<AdvertUploadStatus> uploadAdvert(String token, String title, double price, String description,String category,String owner,List<String> photos, List<DateRange> availability, Location location) async {
  CreateAdvertBody createAdvertBody = CreateAdvertBody(title, price, description, category, owner, photos, availability, location);

  Http.Response response = await Http.post(
      Uri.https(apiBaseURI, "/advert"),
      headers: {"Authorization" : "Bearer $token", "Content-Type": "application/json"},
      body: jsonEncode(createAdvertBody));

  switch(response.statusCode){
    case 201:
      return AdvertUploadStatus.SUCCESS;
    default:
      return AdvertUploadStatus.FAILURE;
  }
}

Future<AdvertUploadStatus> modifyAdvert(String title, double price, String description,String category,String owner,String id, String token, List<String> photoList,List<DateRange> availability, Location location) async {
  CreateAdvertBody createAdvertBody = CreateAdvertBody(title, price, description, category, owner, photoList, availability, location);
  var uri = new Uri.https(apiBaseURI, "/advert/"+id);
  var response = await Http.put(
      uri,
      headers: {"Content-Type": "application/json","Authorization" : "Bearer $token"},
      body : jsonEncode(createAdvertBody));

  switch(response.statusCode){
    case 200:
      return AdvertUploadStatus.SUCCESS;
    default:
      return AdvertUploadStatus.FAILURE;
  }
}

Future<Http.Response> deleteAdvert(String id, String token) async {
  String temp = "/advert/"+id;
  var uri = new Uri.https(apiBaseURI, temp);
  print(uri);
  var response = await Http.delete(uri,headers: {"Authorization" : "Bearer $token","Content-Type": "application/json"});
  print(response.statusCode);
  print(response.body);

  return response;
}

DateRange makeDateRange(Map<String,dynamic> fromJSON){
  return DateRange(DateTime.parse(fromJSON["start"]),DateTime.parse(fromJSON["end"]));
}

Advert decodeAdvert(dynamic jsonAdvert) {
  List<String> photos = new List<String>.from(jsonAdvert["photos"]);
  String categoryName = getCategoryNameByID(jsonAdvert['category']);
  List<double> coordinates = List<double>.from(
      jsonAdvert['location']['coordinates']);
  Location location = Location(
      jsonAdvert['location']['label'], jsonAdvert['location']['city'],
      jsonAdvert['location']['postcode'], coordinates);
  List<DateRange> availability = List<DateRange>();
  List temp = List.from(jsonAdvert["availability"]);
  temp.forEach((item) {
    availability.add(makeDateRange(item));
  });

  return Advert(
    jsonAdvert["_id"],
    jsonAdvert["title"],
    jsonAdvert["price"].toDouble(),
    jsonAdvert["description"],
    photos,
    jsonAdvert["owner"],
    categoryName,
    availability,
    location,
  );
}