

class User {

  String id;
  String name;
  String email;
  String phoneNumber;
  List<String> favorites;

  User({this.id,this.name,this.email,this.phoneNumber,this.favorites});

  setFavorites(List<String> newFavorites){
    favorites = newFavorites;
  }

  bool isInFavorites(String advertId){
    return this.favorites.contains(advertId);
  }
}