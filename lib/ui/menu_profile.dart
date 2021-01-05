import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trops_app/core/data/session_repository.dart';
import 'package:trops_app/core/data/user_repository.dart';

class MenuProfile extends StatefulWidget{

  final SessionRepository sessionRepository;
  final UserRepository userRepository;

  const MenuProfile({
    Key key,
    @required this.sessionRepository,
    @required this.userRepository
  }) : super(key: key);

  @override
  _MenuProfileState createState() => _MenuProfileState();

}

class _MenuProfileState extends State<MenuProfile> {

  TextEditingController _emailController;
  TextEditingController _phoneNumberController;
  TextEditingController _nameController;

  TextEditingController _currentPassword = TextEditingController();
  TextEditingController _newPassword = TextEditingController();
  TextEditingController _confirmationPassword = TextEditingController();

  Color _backgroundCurrentPassword = Colors.white;
  Color _backgroundNewPassword = Colors.white;

  bool _isUpdatingPassword = false;
  bool _isUpdatingEmail = false;
  bool _isUpdatingPhoneNumber = false;
  bool _isUpdatingName = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.sessionRepository.currentUser().email);
    _phoneNumberController = TextEditingController(text: widget.sessionRepository.currentUser().phoneNumber);
    _nameController = TextEditingController(text: widget.sessionRepository.currentUser().name);
  }

  Future<void> showError(String message){
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => SimpleDialog(
        title: Text("Erreur"),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(message),
          ),
        ],
      ),

    );
  }

  void changeEmail() async{
    setState(() {
      _isUpdatingEmail = true;
    });
    try {
      await widget.userRepository.modifyUser("email", _emailController.text);
    } catch (exception) {
      showError("Impossible de modifier le mail, réessayer plus tard");
    }
    setState(() {
      _isUpdatingEmail = false;
    });
  }

  void changePassword() async {
    setState(() {
      _isUpdatingPassword = true;
      _backgroundCurrentPassword = Colors.white;
    });
    if (_newPassword.text == _confirmationPassword.text) {
      setState(() {
        _backgroundNewPassword = Colors.white;
        _backgroundCurrentPassword = Colors.white;
      });
      try {
        await widget.userRepository.modifyPassword(_newPassword.text);
      } catch (Err) {
        showError("Impossible de modifier le mot de passe, veuillez réessayer plus tard");
        setState(() {
          _isUpdatingPassword = false;
        });
        return;
      } finally {
        setState(() {
          _confirmationPassword.text = "";
          _newPassword.text = "";
          _currentPassword.text = "";
        });
      }
    } else {
      setState(() {
        _backgroundNewPassword = Colors.redAccent;
      });
    }
    setState(() {
      _isUpdatingPassword = false;
    });
  }

  void changePhoneNumber() async {
    setState(() {
      _isUpdatingPhoneNumber = true;
    });
    try {
      await widget.userRepository.modifyUser("phoneNumber", _phoneNumberController.text);
    } catch(exception) {
      showError("Impossible de modifiez le numéro de téléphone, veuillez réessayer plus tard");
    } finally {
      setState(() {
        _isUpdatingPhoneNumber = false;
      });
    }
  }

  void changeName() async {
    setState(() {
      _isUpdatingName= true;
    });
    try {
      await widget.userRepository.modifyUser("name", _nameController.text);
    } catch(Err){
      showError("Impossible de modifiez le pseudo, veuillez réessayer plus tard");
    } finally {
      setState(() {
        _isUpdatingName= false;
      });
    }
  }

  Widget _confirmEmail(){
    if(_isUpdatingEmail){
      return CircularProgressIndicator();
    } else {
      return FlatButton(
        child: Text("Confirmer"),
        onPressed: () => changeEmail(),
      );
    }
  }

  Widget _confirmPassword(){
    if(_isUpdatingPassword){
      return CircularProgressIndicator();
    } else {
      return FlatButton(
        child: Text("Confirmer"),
        onPressed: () => changePassword(),
      );
    }
  }

  Widget _confirmPhoneNumber(){
    if(_isUpdatingPhoneNumber){
      return CircularProgressIndicator();
    } else {
      return FlatButton(
        child: Text("Confirmer"),
        onPressed: () => changePhoneNumber(),
      );
    }
  }

  Widget _confirmName(){
    if(_isUpdatingName){
      return CircularProgressIndicator();
    } else {
      return FlatButton(
        child: Text("Confirmer"),
        onPressed: () => changeName(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(25),
              child: Material(
                borderRadius: BorderRadius.circular(20),
                elevation: 5,
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(15),
                      child : Text("Modifiez le mail"),
                    ),
                    TextField(
                      controller: _emailController,
                    ),
                    _confirmEmail(),
                  ],
                ),
              ),
            ),
           Padding(
             padding: EdgeInsets.all(25),
             child: Material(
               borderRadius: BorderRadius.circular(20),
               elevation: 5,
               child:  Column(
                 children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(15),
                      child : Text("Modifiez le mot de passe"),
                    ),
                    TextField(
                      obscureText: true,
                      controller: _currentPassword,
                      decoration: InputDecoration(
                        hintText: "Ancien mot de passe",
                        filled: true,
                        fillColor: _backgroundCurrentPassword,
                      ),
                    ),
                    TextField(
                      obscureText: true,
                      controller: _newPassword,
                      decoration: InputDecoration(
                        hintText: "Nouveau mot de passe",
                        filled: true,
                        fillColor: _backgroundNewPassword,
                      ),
                    ),
                    TextField(
                      obscureText: true,
                      controller: _confirmationPassword,
                      decoration: InputDecoration(
                        hintText: "Confirmation du nouveau mot de passe",
                        filled: true,
                        fillColor: _backgroundNewPassword,
                      ),
                    ),
                    _confirmPassword(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(25),
              child: Material(
                borderRadius: BorderRadius.circular(20),
                elevation: 5,
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(15),
                      child : Text("Modifiez le numero de téléphone"),
                    ),
                    TextField(
                      controller: _phoneNumberController,
                      keyboardType: TextInputType.number,
                    ),
                    _confirmPhoneNumber(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(25),
              child: Material(
                borderRadius: BorderRadius.circular(20),
                elevation: 5,
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(15),
                      child : Text("Modifiez le pseudo"),
                    ),
                    TextField(
                      controller: _nameController,
                    ),
                    _confirmName(),
                  ],
                ),
              ),
            ),
            ExpansionTile(
              leading: Icon(Icons.attach_file),
              title: Text("Conditions Généréles d'Utilisation"),
              children: <Widget>[
                Text("CGU"),
              ],
            ),
            ExpansionTile(
              leading: Icon(Icons.info),
              title: Text("A propos"),
              children: <Widget>[
                Text("Application de location sportive entre particuliers"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}