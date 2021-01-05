
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trops_app/core/data/auth_repository.dart';
import 'package:trops_app/core/data/session_repository.dart';
import 'package:trops_app/core/entity/auth_result.dart';
import 'package:trops_app/core/entity/user.dart';

class SessionRepositoryImpl implements SessionRepository {

  static const String _SP_KEY_TOKEN = 'token';

  static User _currentUser;
  static String _token;
  static bool _isAuthenticated = false;

  AuthRepository _authRepository;

  SessionRepositoryImpl({ @required AuthRepository authRepository }) {
    _authRepository = authRepository;
  }

  @override
  void restoreCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = (prefs.getString(_SP_KEY_TOKEN) ?? null);
    if (token != null){
      AuthResult authResult = await _authRepository.getSession(token);
      if (authResult.isAuthenticated && authResult.user != null){
        _currentUser = authResult.user;
        _token = token;
        _isAuthenticated = true;
      } else {
        //Do nothing, token has probably expired
      }
    }
  }

  @override
  bool isAuthenticated() {
    return _isAuthenticated;
  }

  @override
  User currentUser() {
    return _currentUser;
  }

  @override
  void setCurrentUser(User user) {
    _currentUser = user;
  }

  @override
  String getToken() {
    return _token;
  }

  @override
  void saveToken(String token) async {
    _token = token;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_SP_KEY_TOKEN, token);
  }

  @override
  void forgetToken() async {
    _token = null;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(_SP_KEY_TOKEN);
  }

  @override
  void setAuthenticated(bool isAuthenticated) {
    _isAuthenticated = isAuthenticated;
  }
}

