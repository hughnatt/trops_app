import 'dart:convert';

import 'package:http/http.dart' as Http;
import 'package:trops_app/api/api.dart';
import 'package:trops_app/models/User.dart';

Future<User> getUser(String uid) async {

  var uri = new Uri.https(apiBaseURI, "/users/" + uid);
  var response = await Http.get(uri, headers: {"Content-Type": "application/json"});

  if(response.statusCode == 200) {
    var result = await jsonDecode(response.body);
    User user = User(
        result['name'],
        result['email'],
        null,
        result['phoneNumber'],
        result['_id']
    );
    return user;
  }
  else{
    return null;
  }

}