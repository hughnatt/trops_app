class LoginBody{
  String email;
  String password;

  LoginBody({this.email,this.password});

  Map<String,dynamic> toJson() => {
    'email' : email,
    'password' : password
  };
}