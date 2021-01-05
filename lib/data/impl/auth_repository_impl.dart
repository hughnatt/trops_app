import 'dart:convert' show jsonEncode, jsonDecode;
import 'package:flutter/foundation.dart';
import 'package:trops_app/core/constants.dart';
import 'package:trops_app/core/data/auth_repository.dart';
import 'package:trops_app/core/entity/auth_result.dart';
import 'package:trops_app/core/entity/login_body.dart';
import 'package:trops_app/core/entity/register_body.dart';
import 'package:trops_app/data/http_session.dart';
import 'package:trops_app/data/mapper/auth_result_mapper.dart';

class AuthRepositoryImpl implements AuthRepository {

  HttpSession _httpSession;

  AuthRepositoryImpl({ @required HttpSession httpSession}) {
    this._httpSession = httpSession;
  }

  @override
  Future<AuthResult> register(String name, String email, String password, String phone) {
    RegisterBody registerBody = RegisterBody(name: name, email: email, password: password, phoneNumber: phone);
    return _httpSession.post(
      url: Uri.https(Constants.apiBaseURI, "/users"),
      body: jsonEncode(registerBody),
      mapper: (response) {
        return AuthResultMapper().map(jsonDecode(response));
      }
    );
  }

  @override
  Future<AuthResult> login(String email, String password) {
    LoginBody loginBody = LoginBody(email: email, password: password);
    return _httpSession.post(
      url: Uri.https(Constants.apiBaseURI, "/users/login"),
      body: jsonEncode(loginBody),
      mapper: (response) => AuthResultMapper().map(jsonDecode(response))
    );
  }

  @override
  Future<void> signOff() async {
    return _httpSession.post(
      url: Uri.https(Constants.apiBaseURI, "/users/me/logout")
    );
  }

  @override
  Future<AuthResult> getSession(String token) {
    return _httpSession.get(
      url: Uri.https(Constants.apiBaseURI, '/users/me'),
      mapper: (response) => AuthResultMapper().map(jsonDecode(response))
    );
  }

  @override
  Future<AuthResult> socialLoginWithGoogle(String googleToken) async {
    return _httpSession.get(
      url:  Uri.https(Constants.apiBaseURI, '/auth/google/' + googleToken),
      mapper: (response) => AuthResultMapper().map(jsonDecode(response))
    );
  }
}