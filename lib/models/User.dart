

class User {

  String _id;
  String _name;
  String _email;
  String _phoneNumber;

  User(this._id,this._name,this._email,this._phoneNumber);

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
}