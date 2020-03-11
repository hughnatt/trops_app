

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trops_app/api/auth.dart';
import 'package:trops_app/utils/session.dart';
import 'package:trops_app/api/user.dart';
import 'package:http/http.dart' as Http;

class MenuProfile extends StatefulWidget{

  @override
  _MenuProfileState createState() => _MenuProfileState();

}

class _MenuProfileState extends State<MenuProfile>{

  TextEditingController _emailController = TextEditingController(text: Session.currentUser.getEmail());

  TextEditingController _currentPassword = TextEditingController();
  TextEditingController _newPassword = TextEditingController();
  TextEditingController _confirmationPassword = TextEditingController();

  Color _backgroundCurrentPassword = Colors.white;
  Color _backgroundNewPassword = Colors.white;

  bool _isUpdatingPassword = false;
  bool _isUpdatingEmail = false;

  void changeEmail() async{
    setState(() {
      _isUpdatingEmail = true;
    });
    Http.Response res = await modifyEmail(_emailController.text);
    setState(() {
      _isUpdatingEmail = false;
    });
    print(res.statusCode);
  }

  void changePassword() async {

    setState(() {
      _isUpdatingPassword = true;
    });
    AuthResult resLogin = await login(Session.currentUser.getEmail(),_currentPassword.text);

    if(resLogin.token != null){
      setState(() {
        _backgroundCurrentPassword = Colors.white;
      });
      if(_newPassword.text == _confirmationPassword.text){
        setState(() {
          _backgroundNewPassword = Colors.white;
          _backgroundCurrentPassword = Colors.white;
        });
        Http.Response resModif = await modifyPassword(_newPassword.text);
        print(resModif.statusCode);
        if(resModif.statusCode == 200){
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
    } else {
      setState(() {
        _backgroundCurrentPassword = Colors.redAccent;
      });
    }

    setState(() {
      _isUpdatingPassword = false;
    });
  }

  Widget _confirmEmail(){
    if(_isUpdatingEmail){
      return CircularProgressIndicator(

      );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu"),
      ),

      body: SingleChildScrollView(

        child: Column(

          children: <Widget>[

            Container(
              child: Padding(
                padding: EdgeInsets.all(25),
                child: Column(
                  children: <Widget>[
                    Text("Modifiez le mail"),
                    TextField(
                      controller: _emailController,
                    ),
                    _confirmEmail(),
                  ],
                ),
              ),
            ),

            Container(
              child: Padding(
                padding: EdgeInsets.all(25),
                child: Column(
                  children: <Widget>[
                    Text("Modifiez le mot de passe"),
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