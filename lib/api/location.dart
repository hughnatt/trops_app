import 'package:http/http.dart' as Http;
import 'dart:convert';

import 'package:trops_app/models/Location.dart';

Future<List<Location>> query(String query) async {
  query = query.replaceAll(" ", "+");

  var uri = "https://api-adresse.data.gouv.fr/search/?q=";
  var response = await Http.get(uri + query);

  var result = await jsonDecode(response.body);
  List<Location> cityList = List<Location>();

  try {
    result["features"].forEach((item) {

      Location location = new Location(
        item["properties"]["label"],
        item["properties"]["city"],
        item["properties"]["postcode"]
      );

      cityList.add(location);

    });
  }
  catch (err) {
    print(err);
  }
  return cityList;
}