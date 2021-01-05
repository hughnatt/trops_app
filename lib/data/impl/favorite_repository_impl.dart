import 'dart:convert' show jsonDecode, jsonEncode;

import 'package:flutter/foundation.dart';
import 'package:trops_app/core/constants.dart';
import 'package:trops_app/core/data/favorite_repository.dart';
import 'package:trops_app/core/entity/favorite_body.dart';
import 'package:trops_app/data/http_session.dart';
import 'package:trops_app/data/mapper/favorite_mapper.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {

  HttpSession _httpSession;

  FavoriteRepositoryImpl({ @required HttpSession httpSession }) {
    _httpSession = httpSession;
  }

  @override
  Future<List<String>> addFavorite(String advertId) {
    return _httpSession.put(
        url: Uri.https(Constants.apiBaseURI, "/users/favorites"),
        body: jsonEncode(FavoriteBody(favorite: advertId)),
        mapper: (response) => FavoriteMapper().map(jsonDecode(response))
    );
  }

  @override
  Future<List<String>> deleteFavorite(String advertId) {
    return _httpSession.delete(
        url: Uri.https(Constants.apiBaseURI, "/users/favorites/" + advertId),
        mapper: (response) => FavoriteMapper().map(jsonDecode(response))
    );
  }
}