import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as Http;
import 'package:trops_app/api/constants.dart';
import 'package:trops_app/models/User.dart';
import 'package:trops_app/utils/session.dart';
import 'package:trops_app/utils/sharedPreferences.dart';


class UserResult{
  User user;
  String token;
  bool isAuthenticated;
  String error;
}

class RegisterBody{
  String name;
  String email;
  String password;
  String phoneNumber;

  RegisterBody(this.name,this.email,this.password,this.phoneNumber);
}

class LoginBody{
  String email;
  String password;

  LoginBody(this.email,this.password);
}

Future<User> jsonToUser(String data) async {
  Map json = await jsonDecode(data);
  return User(
      json['user']['_id'],
      json['user']['name'],
      json['user']['email'],
      json['user']['phoneNumber']
  );
}

Future<User> getUser(String uid) async {

  var uri = new Uri.https(apiBaseURI, "/users/" + uid);
  var response = await Http.get(uri, headers: {"Content-Type": "application/json"});

  if(response.statusCode == 200) {
    var result = await jsonDecode(response.body);
    User user = User(
      result['_id'],
      result['name'],
      result['email'],
      result['phoneNumber'],
    );
    return user;
  }
  else{
    return null;
  }

}

Future<UserResult> register(String name, String email, String password, String phone) async {
  RegisterBody registerBody = RegisterBody(name, email, password, phone);

  Http.Response response = await Http.post(
      Uri.https(apiBaseURI, "/users"),
      headers: {"Content-Type": "application/json"},
      body : jsonEncode(registerBody));

  UserResult userResult = UserResult();

  switch(response.statusCode){
    case 201:
      try {
        User user = await jsonToUser(response.body);
        userResult.user = user;
        userResult.isAuthenticated = true;
        userResult.error = null;
      } catch (error){
        userResult.user = null;
        userResult.isAuthenticated = false;
        userResult.error = "Erreur de décodage de l'utilisateur";
      }
      break;
    default:
      userResult.user = null;
      userResult.isAuthenticated = false;
      userResult.error = "Erreur lors du processus d'enregistrement";
      break;
  }

  return userResult;
}

Future<UserResult> login(String email, String password) async {
  LoginBody loginBody = LoginBody(email,password);

  Http.Response response = await Http.post(
      Uri.https(apiBaseURI, "/users/login"),
      headers:  {"Content-Type": "application/json"},
      body : jsonEncode(loginBody));

  UserResult userResult = UserResult();

  switch(response.statusCode){
    case 200:
      try {
        User user = await jsonToUser(response.body);
        userResult.user = user;
        userResult.isAuthenticated = true;
        userResult.error = null;
      } catch (error){
        userResult.user = null;
        userResult.isAuthenticated = false;
        userResult.error = "Erreur de décodage de l'utilisateur";
      }
      break;
    default:
      userResult.user = null;
      userResult.isAuthenticated = false;
      userResult.error = "Erreur lors du processus d'enregistrement";
      break;
  }

  return userResult;
}

Future<UserResult> signOff(User user) async {
  String token = Session.token;
  forgetToken();

  await Http.post(
      Uri.https(apiBaseURI, "/users/me/logout"),
      headers: {"Authorization" : "Bearer $token"});

  UserResult userResult = UserResult();
  userResult.isAuthenticated = false;
  userResult.error = null;
  userResult.user = null;

  return userResult;
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
        User user = User(
            json['_id'],
            json['name'],
            json['email'],
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