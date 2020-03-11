

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trops_app/api/auth.dart';
import 'package:trops_app/utils/session.dart';
import 'package:trops_app/api/user.dart';
import 'package:http/http.dart' as Http;
import 'package:trops_app/api/auth.dart';

class MenuProfile extends StatefulWidget{

  @override
  _MenuProfileState createState() => _MenuProfileState();

}

class _MenuProfileState extends State<MenuProfile>{

  TextEditingController _emailController = TextEditingController(text: Session.currentUser.getEmail());

  TextEditingController _currentPassword = TextEditingController();
  TextEditingController _newPassword = TextEditingController();
  TextEditingController _confirmationPassword = TextEditingController();


  void changeEmail() async{
    Http.Response res = await modifyEmail(_emailController.text);
    print(res.statusCode);
  }

  void changePassword() async {

    AuthResult resLogin = await login(Session.currentUser.getEmail(),_currentPassword.text);

    if(resLogin.token != null){
      if(_newPassword.text == _confirmationPassword.text){
        Http.Response resModif = await modifyPassword(_newPassword.text);
        print(resModif.statusCode);
      }
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
                    FlatButton(
                      child: Text("Confirmer"),
                      onPressed: () => changeEmail(),
                    ),
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
                      ),
                    ),
                    TextField(
                      obscureText: true,
                      controller: _newPassword,
                      decoration: InputDecoration(
                        hintText: "Nouveau mot de passe",
                      ),
                    ),
                    TextField(
                      obscureText: true,
                      controller: _confirmationPassword,
                      decoration: InputDecoration(
                        hintText: "Confirmation du nouveau mot de passe",
                      ),
                    ),
                    FlatButton(
                      child: Text("Confirmer"),
                      onPressed: () => changePassword(),
                    ),
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