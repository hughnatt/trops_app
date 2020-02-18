import 'dart:convert';
import 'package:http/http.dart' as Http;
import 'package:trops_app/api/category.dart';
import 'package:trops_app/models/Advert.dart';

const String _dataBaseURI = "trops.sauton.xyz";

Future<List<Advert>> getResults(String text, int priceMin, int priceMax, String category) async {

  List<Advert> _adverts = new List<Advert>();

  var jsonBody = '''
  {
    "text" : "$text",
    "priceMin" : "$priceMin",
    "priceMax" : "$priceMax"
  }''';
  var uri = new Uri.https(_dataBaseURI, "/search");
  var response = await Http.post(uri, headers: {"Content-Type": "application/json"}, body: jsonBody);

  if(response.statusCode == 200) {
    var result = await jsonDecode(response.body);

    for (var item in result){
      List<String> photos = new List<String>.from(item['photos']);

      //Resolve category name
      String categoryName = getCategoryNameByID(item['category']);

      var advert = new Advert(
          item['_id'],
          item['title'],
          item['price'],
          item['description'],
          photos,
          item['owner'],
          categoryName
      );

      _adverts.add(advert);
    }

    return _adverts;
  } else {
    throw Exception("Failed to get adverts");
  }
}