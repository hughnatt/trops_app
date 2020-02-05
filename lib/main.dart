import 'package:flutter/material.dart';
import 'package:trops_app/ui/profile.dart';
import 'ui/home.dart';

void main() => runApp(TropsApp());

class TropsApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Trop's",
      initialRoute: "/",
      routes: {
        '/' : (context) => HomePage(),
        '/profile' : (context) => ProfilePage()
      },
    );
  }

}