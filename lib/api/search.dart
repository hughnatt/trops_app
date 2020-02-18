import 'dart:convert';
import 'package:http/http.dart' as Http;
import 'package:trops_app/api/api.dart';
import 'package:trops_app/api/category.dart';
import 'package:trops_app/models/Advert.dart';

const String _dataBaseURI = "trops.sauton.xyz";

class SearchBody{
  String text;
  int priceMin;
  int priceMax;
  List<String> categories;
  SearchBody(this.text,this.priceMin,this.priceMax,this.categories);

  Map<String,dynamic> toJson() => {
    'text': text,
    'priceMin': priceMin,
    'priceMax': priceMax,
    'categories': categories
  };
}

Future<List<Advert>> getResults(String text, int priceMin, int priceMax, List<String> categories) async {

  SearchBody body = new SearchBody(text, priceMin, priceMax, categories);

  var uri = new Uri.https(apiBaseURI, "/search");
  var response = await Http.post(uri, headers: {"Content-Type": "application/json"}, body: jsonEncode(body));

  if(response.statusCode == 200) {
    var result = await jsonDecode(response.body);

    List<Advert> _adverts = new List<Advert>();

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