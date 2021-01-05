import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:trops_app/core/constants.dart';
import 'package:trops_app/core/data/category_repository.dart';
import 'package:trops_app/core/data/search_repository.dart';
import 'package:trops_app/core/entity/advert.dart';
import 'package:trops_app/core/entity/search_body.dart';
import 'package:trops_app/data/http_session.dart';
import 'package:trops_app/data/mapper/advert_mapper.dart';

class SearchRepositoryImpl implements SearchRepository {

  HttpSession _httpSession;
  CategoryRepository _categoryRepository;

  SearchRepositoryImpl({
    @required HttpSession httpSession,
    @required CategoryRepository categoryRepository
  }) {
    _httpSession = httpSession;
    _categoryRepository = categoryRepository;
  }

  @override
  Future<List<Advert>> getResults({
    SearchBody searchBody,
    String sortField,
    int sortOrder
  }) async {
    Uri uri = Uri.https(Constants.apiBaseURI, '/search', {'sort' : '$sortField,$sortOrder'});
    return _httpSession.post(
        url: uri,
        body: jsonEncode(searchBody),
        mapper: (response) => AdvertListMapper(categoryRepository: _categoryRepository).map(jsonDecode(response))
    );
  }
}