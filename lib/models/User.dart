

class User {

  static User current;
  String _id;
  String _token;
  String _name;
  String _email;
  String _phoneNumber;
  List<String> _favorites;

  User(this._name,this._email,this._token,this._phoneNumber,this._id,this._favorites);

  getName(){
    return _name;
  }

  getEmail(){
    return _email;
  }

  getToken(){
    return _token;
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