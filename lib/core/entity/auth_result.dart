import 'user.dart';

class AuthResult {
  User user;
  String token;
  bool isAuthenticated;
  String error;

  AuthResult({this.user, this.token, this.isAuthenticated, this.error});
}