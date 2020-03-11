import 'package:shared_preferences/shared_preferences.dart';
import 'package:trops_app/api/auth.dart';
import 'package:trops_app/utils/session.dart';

const String _SP_KEY_TOKEN = 'token';

void restoreCurrentUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = (prefs.getString(_SP_KEY_TOKEN) ?? null);
  if (token != null){
    AuthResult authResult = await getSession(token);
    if (authResult.isAuthenticated && authResult.user != null){
      Session.currentUser = authResult.user;
      Session.token = token;
      Session.isAuthenticated = true;
    } else {
      //Do nothing, token has probably expired
    }
  }
}

void saveToken(String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(_SP_KEY_TOKEN, token);
}

void forgetToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove(_SP_KEY_TOKEN);
}