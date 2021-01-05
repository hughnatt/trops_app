import 'package:trops_app/core/entity/advert.dart';
import 'package:trops_app/core/entity/search_body.dart';

abstract class SearchRepository {
  Future<List<Advert>> getResults({
    SearchBody searchBody,
    String sortField,
    int sortOrder
  });
}