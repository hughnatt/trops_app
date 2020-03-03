import 'dart:convert';
import 'package:http/http.dart' as Http;
import 'package:trops_app/api/api.dart';
import 'package:trops_app/api/category.dart';
import 'package:trops_app/models/Advert.dart';
import 'package:trops_app/models/DateRange.dart';

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
  CreateAdvertBody(this.title,this.price,this.description,this.category,this.owner,this.photos,this.availability);

  Map<String,dynamic> toJson() => {
    'title' : title,
    'price' : price,
    'description' : description,
    'category' : category,
    'owner' : owner,
    'availability' : availability,
    'photos': photos,
  };
}

Future<Http.Response> uploadAdvertApi(String title, double price, String description,String category,String owner,List<String> photos, List<DateRange> availability) async {
  CreateAdvertBody body = CreateAdvertBody(title, price, description, category, owner, photos, availability);
  Uri uri = new Uri.https(apiBaseURI, "/advert");
  Http.Response response = await Http.post(uri,headers: {"Content-Type": "application/json"},body : jsonEncode(body));
  print(response.statusCode);
  print(response.body);
  return response;

}

Future<Http.Response> modifyAdvert(String title, double price, String description,String category,String owner,DateTime beginDate, DateTime endDate, String id, String token) async {
  var jsonBody = '''
  {
    "title" : "$title",
    "price" : $price,
    "description" : "$description",
    "category" : "$category",
    "owner": "$owner",
    "startDate" : "$beginDate",
    "endDate" : "$endDate"
  }''';
  var uri = new Uri.https(apiBaseURI, "/advert/"+id);
  print(jsonBody);
  var response = await Http.put(uri,headers: {"Content-Type": "application/json"},body : jsonBody);
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
  print(uri);
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

Future<Http.Response> deleteAdvert(String id, String token) async {
  String temp = "/advert/"+id;
  var uri = new Uri.https(apiBaseURI, temp);
  print(uri);
  var response = await Http.delete(uri,headers: {"Authorization" : "Bearer $token","Content-Type": "application/json"});
  print(response.statusCode);
  print(response.body);

  return response;
}




//Future<Http.Response> register(String name, String email, String password) async {
//  var jsonBody = '''
//  {
//    "name" : "$name",
//    "email" : "$email",
//    "password" : "$password"
//  }''';
//  var uri = new Uri.https(_authBaseURI, "/users");
//  print(jsonBody);
//  var response = await Http.post(uri,headers: {"Content-Type": "application/json"},body : jsonBody);
//
//  print(response.statusCode);
//  print(response.body);
//  return response;
//}
//
//Future<Http.Response> login(String email, String password) async {
//  var jsonBody = '''
//  {
//    "email" : "$email",
//    "password" : "$password"
//  }''';
//  var uri = new Uri.https(_authBaseURI, "/users/login");
//  var response = await Http.post(uri,headers:  {"Content-Type": "application/json"},body : jsonBody);
//  print(response.statusCode);
//  print(response.body);
//  return response;
//}
//
//Future<Http.Response> signOff(User user) async {
//  String token = user.getToken();
//  print(token);
//  var uri = new Uri.https(_authBaseURI, "/users/me/logout");
//  var response = await Http.post(uri,headers: {"Authorization" : "Bearer $token"});
//  print(response.statusCode);
//  print(response.body);
//  return response;
//}
