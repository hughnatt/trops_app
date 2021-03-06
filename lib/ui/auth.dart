/*
MIT License

Copyright (c) 2018 Hugo EXTRAT

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
Original Version :  https://github.com/huextrat/TheGorgeousLogin/
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:trops_app/api/auth.dart';
import 'package:trops_app/utils/bubble_indication_painter.dart';
import 'package:trops_app/style/theme.dart' as Theme;
import 'package:trops_app/widgets/trops_scaffold.dart';


class AuthPage extends StatefulWidget {
  AuthPage({Key key}) : super(key: key);

  @override
  _AuthPageState createState() => new _AuthPageState();
}

class _AuthPageState extends State<AuthPage>
    with SingleTickerProviderStateMixin {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final FocusNode _focusLoginEmail = FocusNode();
  final FocusNode _focusLoginPassword = FocusNode();
  final FocusNode _focusRegisterName = FocusNode();
  final FocusNode _focusRegisterEmail = FocusNode();
  final FocusNode _focusRegisterPassword = FocusNode();
  final FocusNode _focusRegisterConfirmPassword = FocusNode();
  final FocusNode _focusRegisterPhone = FocusNode();

  TextEditingController _ctrlLoginEmail = new TextEditingController();
  TextEditingController _ctrlLoginPassword = new TextEditingController();
  TextEditingController _ctrlRegisterEmail = new TextEditingController();
  TextEditingController _ctrlRegisterName = new TextEditingController();
  TextEditingController _ctrlRegisterPassword = new TextEditingController();
  TextEditingController _ctrlRegisterConfirmPassword = new TextEditingController();
  TextEditingController _ctrlRegisterPhone = new TextEditingController();

  bool _obscureLoginPassword = true;
  bool _obscureRegisterPassword = true;
  bool _obscureRegisterConfirmPassword = true;

  PageController _pageController;

  Color left = Colors.black;
  Color right = Colors.white;

  @override
  void initState() {
    super.initState();

//    SystemChrome.setPreferredOrientations([
//      DeviceOrientation.portraitUp,
//      DeviceOrientation.portraitDown,
//    ]);

    _pageController = PageController();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    _focusLoginEmail.dispose();
    _focusLoginPassword.dispose();
    _focusRegisterName.dispose();
    _focusRegisterEmail.dispose();
    _focusRegisterPassword.dispose();
    _focusRegisterPhone.dispose();
    _pageController?.dispose();
    super.dispose();
  }

  bool _validatePhonenumber(String text){
    String pattern = r'^(?:(?:\+|00)33|0)\s*[1-9](?:[\s.-]*\d{2}){4}';
    RegExp regex = RegExp(pattern);
    if(regex.hasMatch(text) || text.isEmpty) return true;
    else return false;
  }

  @override
  Widget build(BuildContext context) {
    return TropsScaffold(
      scaffoldKey: _scaffoldKey,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowGlow();
          return false;
        },
        child : SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 75.0),
                //child: new Image(
                //    width: 250.0,
                //    height: 191.0,
                //    fit: BoxFit.fill,
                //    image: new AssetImage('assets/img/abc.png')),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: _buildMenuBar(context),
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (i) {
                    FocusScope.of(context).unfocus();
                    if (i == 0) {
                      setState(() {
                        right = Colors.white;
                        left = Colors.black;
                      });
                    } else if (i == 1) {
                      setState(() {
                        right = Colors.black;
                        left = Colors.white;
                      });
                    }
                  },
                  children: <Widget>[
                    new ConstrainedBox(
                      constraints: const BoxConstraints.expand(),
                      child: _buildSignIn(context),
                    ),
                    new ConstrainedBox(
                      constraints: const BoxConstraints.expand(),
                      child: _buildSignUp(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuBar(BuildContext context) {
    return Container(
      width: 300.0,
      height: 50.0,
      decoration: BoxDecoration(
        color: Color(0x552B2B2B),
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
      child: CustomPaint(
        painter: TabIndicationPainter(pageController: _pageController),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: FlatButton(
                //splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _onSignInButtonPress,
                child: Text(
                  "Connexion",
                  style: TextStyle(
                      color: left,
                      fontSize: 16.0,
                      fontFamily: "WorkSansSemiBold"),
                ),
              ),
            ),
            //Container(height: 33.0, width: 1.0, color: Colors.white),
            Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _onSignUpButtonPress,
                child: Text(
                  "Inscription",
                  style: TextStyle(
                      color: right,
                      fontSize: 16.0,
                      fontFamily: "WorkSansSemiBold"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignIn(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 23.0),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              Card(
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  width: 300.0,
                  height: 190.0,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: _focusLoginEmail,
                          controller: _ctrlLoginEmail,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.envelope,
                              color: Colors.black,
                              size: 22.0,
                            ),
                            hintText: "Email",
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold", fontSize: 17.0),
                          ),
                          onSubmitted: (value) => FocusScope.of(context).requestFocus(_focusLoginPassword),
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: _focusLoginPassword,
                          controller: _ctrlLoginPassword,
                          obscureText: _obscureLoginPassword,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.lock,
                              size: 22.0,
                              color: Colors.black,
                            ),
                            hintText: "Mot de passe",
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold", fontSize: 17.0),
                            suffixIcon: GestureDetector(
                              onTap: _toggleLoginPassword,
                              child: Icon(_obscureLoginPassword ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
                                size: 15.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          onSubmitted: (value) => _handleLogin(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 170.0),
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Theme.Colors.loginGradientStart,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 10.0,
                    ),
                    BoxShadow(
                      color: Theme.Colors.loginGradientEnd,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 10.0,
                    ),
                  ],
                  color: Colors.white,
                ),
                child: MaterialButton(
                    highlightColor: Colors.transparent,
                    //splashColor: Theme.Colors.loginGradientEnd,
                    //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 42.0),
                      child: Text(
                        'CONNEXION',
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 20.0,
                            fontFamily: "WorkSansBold"),
                      ),
                    ),
                    onPressed: () => _handleLogin()
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            //child: FlatButton(
            //    onPressed: () {},
            //    child: Text(
            //      "Mot de passe oublié ?",
            //      style: TextStyle(
            //          decoration: TextDecoration.underline,
            //          color: Colors.black,
            //          fontSize: 16.0,
            //          fontFamily: "WorkSansMedium"),
            //    )),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    gradient: new LinearGradient(
                        colors: [
                          Colors.white10,
                          Colors.black87,
                        ],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(1.0, 1.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  width: 100.0,
                  height: 1.0,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Text(
                    "OU",
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16.0,
                        fontFamily: "WorkSansMedium"),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: new LinearGradient(
                        colors: [
                          Colors.black87,
                          Colors.white10,
                        ],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(1.0, 1.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  width: 100.0,
                  height: 1.0,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 20.0, right: 40.0),
                child: GestureDetector(
                  onTap: () => _displayAlert("Indisponible"),
                  child: Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black87,
                    ),
                    child: new Icon(
                      FontAwesomeIcons.facebookF,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: GestureDetector(
                  onTap: () => _handleGoogle(),
                  child: Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black87,
                    ),
                    child: new Icon(
                      FontAwesomeIcons.google,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSignUp(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 23.0),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              Card(
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  width: 300.0,
                  height: 450.0,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: _focusRegisterName,
                          controller: _ctrlRegisterName,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.user,
                              color: Colors.black,
                            ),
                            hintText: "Nom",
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold", fontSize: 16.0),
                          ),
                          onSubmitted: (value) => FocusScope.of(context).requestFocus(_focusRegisterEmail),
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: _focusRegisterEmail,
                          controller: _ctrlRegisterEmail,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.envelope,
                              color: Colors.black,
                            ),
                            hintText: "Email",
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold", fontSize: 16.0),
                          ),
                          onSubmitted: (value) => FocusScope.of(context).requestFocus(_focusRegisterPassword)
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: _focusRegisterPhone,
                          controller: _ctrlRegisterPhone,
                          keyboardType: TextInputType.phone,
                          textCapitalization: TextCapitalization.words,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.phoneAlt,
                              color: Colors.black,
                            ),
                            hintText: "Téléphone",
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold", fontSize: 16.0),
                          ),
                          onSubmitted: (value) => FocusScope.of(context).requestFocus(_focusRegisterPhone),
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: _focusRegisterPassword,
                          controller: _ctrlRegisterPassword,
                          obscureText: _obscureRegisterPassword,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.lock,
                              color: Colors.black,
                            ),
                            hintText: "Mot de passe",
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold", fontSize: 16.0),
                            suffixIcon: GestureDetector(
                              onTap: _toggleRegisterPassword,
                              child: Icon(_obscureRegisterPassword ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
                                size: 15.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          onSubmitted: (value) => FocusScope.of(context).requestFocus(_focusRegisterConfirmPassword)
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: _focusRegisterConfirmPassword,
                          controller: _ctrlRegisterConfirmPassword,
                          obscureText: _obscureRegisterConfirmPassword,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.lock,
                              color: Colors.black,
                            ),
                            hintText: "Confirmation",
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold", fontSize: 16.0),
                            suffixIcon: GestureDetector(
                              onTap: _toggleRegisterConfirmPassword,
                              child: Icon(_obscureRegisterConfirmPassword ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
                                size: 15.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          onSubmitted: (value) => _handleRegister(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 440.0),
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Theme.Colors.loginGradientStart,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 10.0,
                    ),
                    BoxShadow(
                      color: Theme.Colors.loginGradientEnd,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 10.0,
                    ),
                  ],
                  color:  Colors.white
                ),
                child: MaterialButton(
                    highlightColor: Colors.transparent,
                    //splashColor: Theme.Colors.loginGradientEnd,
                    //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 42.0),
                      child: Text(
                        "INSCRIPTION",
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 20.0,
                            fontFamily: "WorkSansBold"),
                      ),
                    ),
                    onPressed: () => _handleRegister()
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _displayAlert(String text){
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Erreur"),
        content: Text(text),
        actions: [
          FlatButton(
            child: Text("Annuler"),
            onPressed: () {Navigator.pop(context);},
          ),
        ],
      ),
    );
  }

  void _onSignInButtonPress() {
    _pageController.animateToPage(0, duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _onSignUpButtonPress() {
    _pageController?.animateToPage(1, duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _toggleLoginPassword() {
    setState(() {
      _obscureLoginPassword = !_obscureLoginPassword;
    });
  }

  void _toggleRegisterPassword() {
    setState(() {
      _obscureRegisterPassword = !_obscureRegisterPassword;
    });
  }

  void _toggleRegisterConfirmPassword() {
    setState(() {
      _obscureRegisterConfirmPassword = !_obscureRegisterConfirmPassword;
    });
  }

  void _handleRegister() async {
    if (_ctrlRegisterPassword.text != _ctrlRegisterConfirmPassword.text){
      _displayAlert("Les mots de passe ne correspondent pas.");
      FocusScope.of(context).requestFocus(_focusRegisterConfirmPassword);
    }
    else if(!_validatePhonenumber(_ctrlRegisterPhone.text)){
      _displayAlert("Le numéro de téléphone n'est pas valide.");
      FocusScope.of(context).requestFocus(_focusRegisterPhone);
    }
    else if(_ctrlRegisterName.text.isEmpty){
      _displayAlert("Le nom n'est pas renseigné.");
      FocusScope.of(context).requestFocus(_focusRegisterName);
    }
    else if(_ctrlRegisterEmail.text.isEmpty){
      _displayAlert("Le mail n'est pas renseigné.");
      FocusScope.of(context).requestFocus(_focusLoginEmail);
    }
    else{
      AuthResult authResult = await register(_ctrlRegisterName.text, _ctrlRegisterEmail.text, _ctrlRegisterPassword.text, _ctrlRegisterPhone.text);
      if(authResult.isAuthenticated && authResult != null){
        Navigator.pop(context);
        Navigator.pushNamed(context, ModalRoute.of(context).settings.arguments);
      } else {
        _displayAlert("Echec de l'inscription.");
        FocusScope.of(context).requestFocus(_focusRegisterName);
      }
    }
  }

  void _handleLogin() async {
    AuthResult authResult = await login(_ctrlLoginEmail.text, _ctrlLoginPassword.text);
    if (authResult.isAuthenticated && authResult.user != null){

      String _futureRoute = ModalRoute.of(context).settings.arguments;
      if(_futureRoute == null) _futureRoute = "/home";
      Navigator.pop(context);
      Navigator.pushNamed(context, _futureRoute);
    } else {
      _displayAlert("Les identifiants fournis sont incorrects.");
    }
  }

  void _handleGoogle() async {
    GoogleSignInAuthentication googleSignInAuthentication;
    try {
      await googleSignIn.signIn();
      googleSignInAuthentication = await googleSignIn.currentUser.authentication;
    } catch(error) {
      print(error);
      _displayAlert("Echec de l'authentification");
    }

    AuthResult authResult = await socialLoginWithGoogle(googleSignInAuthentication.idToken);
    if (authResult.isAuthenticated && authResult.user != null) {
      Navigator.popAndPushNamed(context, ModalRoute.of(context).settings.arguments);
    } else {
      _displayAlert("Echec de l'authentification");
    }
  }
}