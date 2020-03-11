

class User {

  static User current;
  String _id;
  String _token;
  String _name;
  String _email;
  String _phoneNumber;

  User(this._name,this._email,this._token,this._phoneNumber,this._id);

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
}