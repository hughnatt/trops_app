import 'dart:convert';
import 'package:http/http.dart' as Http;
import 'package:trops_app/api/constants.dart';
import 'package:trops_app/models/User.dart';

User parseUser(Map json) {
  return User(
      json['_id'],
      json['name'],
      json['email'],
      json['phoneNumber'],
      null //We don't want to get the favorite of the owner of the advert
  );
}

Future<User> getUser(String uid) async {

  var uri = new Uri.https(apiBaseURI, "/users/" + uid);
  var response = await Http.get(uri, headers: {"Content-Type": "application/json"});

  if(response.statusCode == 200) {

    var result = await jsonDecode(response.body);

    User user = User(
        result['name'],
        result['email'],
        result['phoneNumber'],
        result['_id'],
        null //we don't want to get the user's favorites
    );
    return user;
  }
  else{
    return null;
  }
}


