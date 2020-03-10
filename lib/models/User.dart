

class User {

  static User current;
  String _id;
  String _token;
  String _name;
  String _email;

  User(this._id, this._name,this._email,this._token);

  getId(){
    return _id;
  }

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