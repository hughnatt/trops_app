import 'dart:convert';
import 'package:http/http.dart' as Http;
import 'package:trops_app/api/category.dart';
import 'package:trops_app/models/Advert.dart';

var _dataBaseURI = "trops.sauton.xyz";

Future<List<Advert>> getAllAdverts() async {

  List<Advert> _adverts = new List<Advert>();
  var uri = new Uri.https(_dataBaseURI, "/advert");
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
        item["price"],
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

Future<Http.Response> uploadAdvert(String title, int price, String description,String category,String owner,DateTime beginDate, DateTime endDate) async {
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
  var uri = new Uri.https(_dataBaseURI, "/advert");
  print(jsonBody);
  var response = await Http.post(uri,headers: {"Content-Type": "application/json"},body : jsonBody);
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