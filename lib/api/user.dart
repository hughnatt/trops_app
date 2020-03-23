import 'dart:convert';
import 'package:http/http.dart' as Http;
import 'package:trops_app/api/constants.dart';
import 'package:trops_app/models/User.dart';
import 'package:trops_app/utils/session.dart';


enum favoritesEnum { Additon, Deletion }

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
        result['_id'],
        result['name'],
        result['email'],
        result['phoneNumber'],
        null  /*we don't want to get the user's favorites*/
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


/*Future<List<String>> updateFavorites(String advertId,favoritesEnum operation) async{

  String token = Session.token;
  var response;

  switch(operation){
    case favoritesEnum.Additon:
      {
        var uri = new Uri.https(apiBaseURI, "/users/favorites");
        FavoriteBody body = new FavoriteBody(advertId);
        response = await Http.put(uri, headers: {"Authorization" : "Bearer $token","Content-Type": "application/json"}, body: jsonEncode(body));
      }
      break;

    case favoritesEnum.Deletion:
      {
      var uriDelete = Uri.https(apiBaseURI, "/users/favorites/"+advertId);
      response = await Http.delete(uriDelete, headers: {"Authorization" : "Bearer $token","Content-Type": "application/json"});
      }
    break;

    default:
      {
        throw Exception("Failed to update favorites");
      }
      break;
  }


  print("FAVORITES RESPONSE " + response.statusCode);

  if(response.statusCode == 200) {
    var result = await jsonDecode(response.body);

    List<String> _userFavorite = new List<String>();

    for (var item in result){
     _userFavorite.add(item); //add each advertId in the favoriteList to return
    }

    return _userFavorite;
  }
  else {
    throw Exception("Failed to update favorites");
  }
}*/

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



Future<List<String>> deleteFavorite(String advertId) async{

  var uriDelete = Uri.https(apiBaseURI, "/users/favorites/"+advertId);

  String token = Session.token;


  var response = await Http.delete(uriDelete, headers: {"Authorization" : "Bearer $token","Content-Type": "application/json"});



  if(response.statusCode == 200) {
    var result = await jsonDecode(response.body);

    List<String> _userFavorite = new List<String>();

    for (var item in result){
      _userFavorite.add(item); //add each advertId in the favoriteList to return
    }

    return _userFavorite;
  }
  else {
    throw Exception("Failed to delete favorite");
  }
}



