import 'package:flutter/material.dart';
import 'package:trops_app/ui/auth.dart';
import 'package:trops_app/ui/profile.dart';
import 'package:trops_app/ui/searchresult.dart';
import 'ui/home.dart';
import 'models/User.dart';

void main() => runApp(TropsApp());

class TropsApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Trop's",
      initialRoute: "/",
      routes: {
        '/' : (context) => HomePage(),
        '/search' : (context) => SearchResultPage(),
        '/auth' : (context) => AuthPage(),
      },
    );
  }

}