class RegisterBody{
  final String name;
  final String email;
  final String password;
  final String phoneNumber;

  const RegisterBody({this.name,this.email,this.password,this.phoneNumber});

  Map<String,dynamic> toJson() => {
    'name' : name,
    'email' : email,
    'password' : password,
    'phoneNumber' : phoneNumber
  };
}