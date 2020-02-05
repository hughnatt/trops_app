import 'package:http/http.dart' as Http;
import 'package:trops_app/models/User.dart';

var _authBaseURI = "trops.sauton.xyz";

Future<Http.Response> register(String name, String email, String password) async {
  var jsonBody = '''
  {
    "name" : "$name",
    "email" : "$email",
    "password" : "$password"
  }''';
  var uri = new Uri.https(_authBaseURI, "/users");
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
  var uri = new Uri.https(_authBaseURI, "/users/login");
  var response = await Http.post(uri,headers:  {"Content-Type": "application/json"},body : jsonBody);
  print(response.statusCode);
  print(response.body);
  return response;
}

Future<Http.Response> signOff(User user) async {
  String token = user.getToken();
  print(token);
  var uri = new Uri.https(_authBaseURI, "/users/me/logout");
  var response = await Http.post(uri,headers: {"Authorization" : "Bearer $token"});
  print(response.statusCode);
  print(response.body);
  return response;
}