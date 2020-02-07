

class User {

  static User current;

  String _token;
  String _name;
  String _email;

  User(this._name,this._email,this._token);

  getName(){
    return _name;
  }

  getEmail(){
    return _email;
  }

  getToken(){
    return _token;
  }
}