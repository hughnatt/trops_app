

class User {

  String _id;
  String _name;
  String _email;
  String _phoneNumber;
  List<String> _favorites;

  User(this._id,this._name,this._email,this._phoneNumber,this._favorites);

  getName(){
    return _name;
  }

  getEmail(){
    return _email;
  }

  getPhoneNumber(){
    return _phoneNumber;
  }

  getId(){
    return _id;
  }

  getFavorites(){
    return _favorites;
  }

  isInFavorites(String advertId){
    return this._favorites.contains(advertId);
  }
}