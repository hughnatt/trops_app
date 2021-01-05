import 'dart:convert' show jsonDecode;
import 'package:flutter/foundation.dart';
import 'package:trops_app/core/constants.dart';
import 'package:trops_app/core/data/user_repository.dart';
import 'package:trops_app/core/entity/user.dart';
import 'package:trops_app/data/http_session.dart';
import 'package:trops_app/data/mapper/user_mapper.dart';

class UserRepositoryImpl implements UserRepository {

  HttpSession _httpSession;

  UserRepositoryImpl({ @required HttpSession httpSession }) {
    _httpSession = httpSession;
  }

  @override
  Future<User> getUser(String uid) {
    return _httpSession.get(
      url: Uri.https(Constants.apiBaseURI, "/users/" + uid),
      mapper: (response) => UserMapper().map(jsonDecode(response))
    );
  }

  @override
  Future<void> modifyPassword(String password) {
    return _httpSession.put(
      url: Uri.https(Constants.apiBaseURI, "/users/me/password"),
      body: '''
        {
          "password" : "$password"
        }
      '''
    );
  }

  @override
  Future<void> modifyUser(String field, String value) {
    return _httpSession.put(
      url: Uri.https(Constants.apiBaseURI, "/users/me"),
      body: '''
        {
          "$field" : "$value"
        }
      '''
    );
  }
}



