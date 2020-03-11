import 'dart:convert';

import 'package:http/http.dart' as Http;
import 'package:trops_app/api/constants.dart';
import 'package:trops_app/models/User.dart';
import 'package:trops_app/utils/sharedPreferences.dart';

Future<Http.Response> register(String name, String email, String password, String phone) async {
  var jsonBody = '''
  {
    "name" : "$name",
    "email" : "$email",
    "password" : "$password",
    "phoneNumber" : "$phone"
  }''';
  var uri = new Uri.https(apiBaseURI, "/users");
  print(jsonBody);
  var response = await Http.post(uri,headers: {"Content-Type": "application/json"},body : jsonBody);

  print(response.statusCode);
  print(response.body);
  return response;
}

Future<Http.Response> login(String email, String password) async {
  var jsonBody = '''
  {
    "email" : "$email",
    "password" : "$password"
  }''';
  var uri = new Uri.https(apiBaseURI, "/users/login");
  var response = await Http.post(uri,headers:  {"Content-Type": "application/json"},body : jsonBody);
  print(response.statusCode);
  print(response.body);
  return response;
}

Future<Http.Response> signOff(User user) async {
  String token = user.getToken();
  forgetToken();
  var uri = new Uri.https(apiBaseURI, "/users/me/logout");
  var response = await Http.post(uri,headers: {"Authorization" : "Bearer $token"});
  print(response.statusCode);
  print(response.body);
  return response;
}


class UserResult{
  User user;
  bool isAuthenticated;
  String error;
}

Future<UserResult> getSessionByToken(String token) async {
  Http.Response res = await Http.get(
      Uri.https(apiBaseURI, '/users/me'),
      headers: {"Authorization" : "Bearer $token"});

  UserResult userResult = UserResult();
  switch(res.statusCode){
    case 200:
      try {
        Map json = jsonDecode(res.body);
        print(json);
        User user = User(json['_id'],
            json['name'],
            json['email'],
            token,
            json['phoneNumber']
        );
        userResult.isAuthenticated = true;
        userResult.user = user;
        userResult.error = null;
      } catch(error){
        userResult.isAuthenticated = false;
        userResult.user = null;
        userResult.error = error;
      }
      break;
    default:
      userResult.isAuthenticated = false;
      userResult.user = null;
      userResult.error = "Echec de l'authentification";
      break;
  }

  return userResult;
}