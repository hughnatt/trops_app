import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as Http;
import 'package:trops_app/api/constants.dart';
import 'package:trops_app/models/User.dart';
import 'package:trops_app/utils/session.dart';
import 'package:trops_app/utils/sharedPreferences.dart';


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


