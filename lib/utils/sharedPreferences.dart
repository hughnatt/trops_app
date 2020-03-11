

import 'package:shared_preferences/shared_preferences.dart';
import 'package:trops_app/api/auth.dart';
import 'package:trops_app/models/User.dart';

final String _SP_KEY_TOKEN = 'token';

void restoreCurrentUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = (prefs.getString(_SP_KEY_TOKEN) ?? null);
  if (token != null){
    UserResult userResult = await getSessionByToken(token);
    if (userResult.isAuthenticated && userResult.user != null){
      print(userResult.user);
      User.current = userResult.user;
      print(User.current.getEmail());
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