import 'dart:convert';
import 'package:http/http.dart' as Http;
import 'package:trops_app/api/constants.dart';
import 'package:trops_app/models/User.dart';
import 'package:trops_app/utils/session.dart';

class FavoriteBody{
  String _favorite;

  FavoriteBody(this._favorite);

  Map<String,dynamic> toJson() => {
    'favorite': _favorite
  };
}


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


Future<List<String>> addFavorite(String advertId) async{

  FavoriteBody body = new FavoriteBody(advertId);

  var uri = new Uri.https(apiBaseURI, "/users/favorites");

  String token = Session.token;

  var response = await Http.put(uri, headers: {"Authorization" : "Bearer $token","Content-Type": "application/json"}, body: jsonEncode(body));

  if(response.statusCode == 200) {
    var result = await jsonDecode(response.body);

    List<String> _userFavorite = new List<String>();

    for (var item in result){
     _userFavorite.add(item); //add each advertId in the favoriteList to return
    }

    return _userFavorite;
  }
  else {
    throw Exception("Failed to get adverts");
  }
}


