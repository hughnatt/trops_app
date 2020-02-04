

class User {

  static User current;

  String _token;
  String _name;
  String _email;

  getName(){
    return _name;
  }

  getEmail(){
    return _email;
  }
}