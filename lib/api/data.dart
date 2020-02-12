import 'dart:convert';
import 'package:http/http.dart' as Http;
import 'package:trops_app/models/Advert.dart';

var _dataBaseURI = "trops.sauton.xyz";

Future<List<Advert>> getAllAdverts() async {

  List<Advert> _adverts = new List<Advert>();
  var uri = new Uri.https(_dataBaseURI, "/advert");
  var response = await Http.get(uri, headers: {"Content-Type": "application/json"});

  if(response.statusCode == 200) {

    var result = await jsonDecode(response.body);
    result.forEach((item){

      List<String> photos = new List<String>.from(item["photos"]);

      var advert = new Advert(
        item["title"],
        item["price"],
        item["description"],
        photos,
        item["owner"],
        item["category"]
      );

      _adverts.add(advert);

    });

    return _adverts;

  }
  else {
    throw Exception("Failed to get adverts");
  }
  
}

Future<List<String>> getCategories() async {

  List<String> categories = new List<String>();
  var uri = new Uri.https(_dataBaseURI, "/category");
  var response = await Http.get(uri, headers: {"Content-Type": "application/json"});

  if(response.statusCode == 200) {

    var result = await jsonDecode(response.body);
    result.forEach((item) {
      categories.add(item["categoryName"]);
    });

    return categories;
  }
  else {
    throw Exception("Failed to get categories");
  }
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