import 'dart:convert';
import 'package:http/http.dart' as Http;
import 'package:trops_app/models/Advert.dart';

var _dataBaseURI = "trops.sauton.xyz";

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
    result.forEach((item) {
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
    print(_adverts);
    return _adverts;
  } else {
    throw Exception("Failed to get adverts");
  }
}