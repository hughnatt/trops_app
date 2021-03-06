import 'package:trops_app/api/constants.dart';
import 'package:trops_app/models/TropsCategory.dart';
import 'dart:convert';
import 'package:http/http.dart' as Http;

Map<String,String> _categoryNameCache = Map<String,String>();

Future<List<TropsCategory>> getCategories() async {

  List<TropsCategory> categories = List<TropsCategory>();
  var uri = Uri.https(apiBaseURI, "/category");
  var response = await Http.get(uri, headers: {"Content-Type": "application/json"});

  if(response.statusCode == 200) {

    var result = await jsonDecode(response.body);


    result.forEach((item) {
      if (item['description'] == null){
        item['description'] = "";
      }
      if (item['thumbnail'] == null){
        item['thumbnail'] = "";
      }
      TropsCategory tropsCategory = TropsCategory(item['_id'], item['name'], item['description'], item['thumbnail'], getSubcategories(item['name'],item['children']));
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
      if (item['description'] == null){
        item['description'] = "";
      }
      if (item['thumbnail'] == null){
        item['thumbnail'] = "";
      }
      TropsCategory tropsCategory = TropsCategory(
          item['_id'], item['name'], item['description'], item['thumbnail'], getSubcategories(name,item['children']));
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

String getIDByCategoryName(String name) {
  String id;
  _categoryNameCache.forEach((key,value){
    if(value == name){
      id = key;
    }
  });
  if (id == null){
    id = "";
  }
  return id;
}