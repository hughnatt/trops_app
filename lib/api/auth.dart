
import 'dart:convert' show jsonEncode, jsonDecode;
import 'package:http/http.dart' as Http;
import 'package:trops_app/api/constants.dart';
import 'package:trops_app/models/User.dart';
import 'package:trops_app/utils/session.dart';
import 'package:trops_app/utils/sharedPreferences.dart' as Cache;

class AuthResult {
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

  Map<String,dynamic> toJson() => {
    'name' : name,
    'email' : email,
    'password' : password,
    'phoneNumber' : phoneNumber
  };
}

class LoginBody{
  String email;
  String password;

  LoginBody(this.email,this.password);

  Map<String,dynamic> toJson() => {
    'email' : email,
    'password' : password
  };
}

User parseAuthUser(Map json) {
  return User(
      json['user']['_id'],
      json['user']['name'],
      json['user']['email'],
      json['user']['phoneNumber']
  );
}

String parseToken(Map json) {
  return json['token'];
}

Future<AuthResult> register(String name, String email, String password, String phone) async {
  RegisterBody registerBody = RegisterBody(name, email, password, phone);

  Http.Response response = await Http.post(
      Uri.https(apiBaseURI, "/users"),
      headers: {"Content-Type": "application/json"},
      body : jsonEncode(registerBody));

  AuthResult authResult = AuthResult();

  switch(response.statusCode){
    case 201:
      try {
        Map json = await jsonDecode(response.body);
        User user = parseAuthUser(json);
        authResult.user = user;
        authResult.token = parseToken(json);
        authResult.isAuthenticated = true;
        Session.currentUser = authResult.user;
        Session.token = authResult.token;
        Session.isAuthenticated = true;
        Cache.saveToken(Session.token);
      } catch (error){
        authResult.isAuthenticated = false;
        authResult.error = "Erreur de décodage de l'utilisateur";
      }
      break;
    default:
      authResult.isAuthenticated = false;
      authResult.error = "Erreur lors du processus d'enregistrement";
      break;
  }

  return authResult;
}

Future<AuthResult> login(String email, String password) async {
  LoginBody loginBody = LoginBody(email,password);

  Http.Response response = await Http.post(
      Uri.https(apiBaseURI, "/users/login"),
      headers:  {"Content-Type": "application/json"},
      body : jsonEncode(loginBody));

  AuthResult authResult = AuthResult();

  switch(response.statusCode){
    case 200:
      try {
        Map json = await jsonDecode(response.body);
        User user = parseAuthUser(json);
        authResult.user = user;
        authResult.token = parseToken(json);
        authResult.isAuthenticated = true;
        Session.currentUser = authResult.user;
        Session.token = authResult.token;
        Session.isAuthenticated = true;
        Cache.saveToken(Session.token);
      } catch (error){
        authResult.isAuthenticated = false;
        authResult.error = "Erreur de décodage de l'utilisateur";
      }
      break;
    default:
      authResult.user = null;
      authResult.isAuthenticated = false;
      authResult.error = "Erreur lors du processus d'enregistrement";
      break;
  }

  return authResult;
}

Future<AuthResult> signOff() async {
  String token = Session.token;
  Cache.forgetToken();

  await Http.post(
      Uri.https(apiBaseURI, "/users/me/logout"),
      headers: {"Authorization" : "Bearer $token"});

  AuthResult authResult = AuthResult();
  authResult.isAuthenticated = false;
  authResult.error = null;
  authResult.user = null;

  Session.currentUser = null;
  Session.isAuthenticated = false;
  Session.token = null;

  return authResult;
}

Future<AuthResult> getSession(String token) async {
  Http.Response res = await Http.get(
      Uri.https(apiBaseURI, '/users/me'),
      headers: {"Authorization" : "Bearer $token"});

  AuthResult authResult = AuthResult();
  switch(res.statusCode){
    case 200:
      try {
        Map json = jsonDecode(res.body);
        User user = User(
            json['_id'],
            json['name'],
            json['email'],
            json['phoneNumber']
        );
        authResult.isAuthenticated = true;
        authResult.user = user;
        authResult.error = null;
        Session.currentUser = user;
        Session.token = token;
        Session.isAuthenticated = true;
      } catch(error){
        authResult.isAuthenticated = false;
        authResult.user = null;
        authResult.error = error;
      }
      break;
    default:
      authResult.isAuthenticated = false;
      authResult.user = null;
      authResult.error = "Echec de l'authentification";
      break;
  }

  return authResult;
}