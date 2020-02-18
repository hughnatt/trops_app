import 'package:trops_app/models/TropsCategory.dart';
import 'dart:convert';
import 'package:http/http.dart' as Http;

const String _dataBaseURI = "trops.sauton.xyz";

Map<String,String> _categoryNameCache = Map<String,String>();

Future<List<TropsCategory>> getCategories() async {

  List<TropsCategory> categories = List<TropsCategory>();
  var uri = Uri.https(_dataBaseURI, "/category");
  var response = await Http.get(uri, headers: {"Content-Type": "application/json"});

  if(response.statusCode == 200) {

    var result = await jsonDecode(response.body);
    result.forEach((item) {
      TropsCategory tropsCategory = TropsCategory(item['_id'], item['name'], getSubcategories(item['name'],item['children']));
      categories.add(tropsCategory);
      _categoryNameCache.addAll({item['_id'] : item['name']});
    });

    return categories;
  }
  else {
    throw Exception("Failed to get categories");
  }
}

List<TropsCategory> getSubcategories(parentName,json) {
  List<TropsCategory> subcategories = List<TropsCategory>();
  if (json != null) {
    json.forEach((item) {
      var name = parentName + "/" + item['name'];
      TropsCategory tropsCategory = TropsCategory(
          item['_id'], item['name'], getSubcategories(name,item['children']));
      subcategories.add(tropsCategory);
      _categoryNameCache.addAll({item['_id'] : name});
    });
  }
  return subcategories;
}

String getCategoryNameByID(String id) {
  String name = _categoryNameCache[id];
  if (name == null){
    name = "";
  }
  return name;
}