import 'package:trops_app/core/entity/user.dart';

class UserMapper {
  User map(Map json, {bool parseFavorites = false}) {
    List<String> favorites;
    if (parseFavorites) {
      favorites = List<String>.from(json['user']['favorites']);
    }
    return User(
        id: json['_id'],
        name: json['name'],
        email: json['email'],
        phoneNumber: json['phoneNumber'],
        favorites: favorites
    );
  }
}