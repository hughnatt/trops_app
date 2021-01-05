import 'package:http/http.dart' as Http;
import 'dart:convert';

import 'package:trops_app/core/data/location_repository.dart';
import 'package:trops_app/core/entity/location.dart';

class LocationRepositoryImpl implements LocationRepository {

  @override
  Future<List<Location>> query(String query) async {
    query = query.replaceAll(" ", "+");

    var uri = "https://api-adresse.data.gouv.fr/search/?q=";
    var response = await Http.get(uri + query);

    var result = await jsonDecode(response.body);
    List<Location> cityList = List<Location>();

    try {
      result["features"].forEach((item) {

        List<double> coordinates = new List<double>.from(item["geometry"]["coordinates"]);

        Location location = new Location(
            item["properties"]["label"],
            item["properties"]["city"],
            item["properties"]["postcode"],
            coordinates
        );

        cityList.add(location);

      });
    }
    catch (err) {
      print(err);
    }
    return cityList;
  }
}