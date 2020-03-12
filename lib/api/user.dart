import 'dart:convert';
import 'package:http/http.dart' as Http;
import 'package:trops_app/api/constants.dart';
import 'package:trops_app/models/User.dart';
import 'package:trops_app/utils/session.dart';

User parseUser(Map json) {
  return User(
      json['_id'],
      json['name'],
      json['email'],
      json['phoneNumber']
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

Future<Http.Response> modifyPassword(String password) async {

  Uri uri = Uri.https(apiBaseURI, "/users/me/password");
  String token = Session.token;
  var jsonBody = '''
  {
    "password" : "$password"
  }
  ''';

  Http.Response response = await Http.put(uri, headers: {"Authorization" : "Bearer $token", "Content-Type": "application/json"}, body: jsonBody);

  return response;

}

Future<Http.Response> modifyUser(String field, String value) async {

  Uri uri = Uri.https(apiBaseURI, "/users/me");
  String token = Session.token;
  var jsonBody = '''
  {
    "$field" : "$value"
  }
  ''';

  Http.Response response = await Http.put(uri, headers: {"Authorization" : "Bearer $token", "Content-Type": "application/json"}, body: jsonBody);

  return response;

}


