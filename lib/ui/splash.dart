

import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:trops_app/ui/home.dart';
import 'package:trops_app/utils/sharedPreferences.dart';

class SplashPage extends StatefulWidget {
  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage>{

  @override
  void initState() {
    super.initState();
    restoreCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 5,
      navigateAfterSeconds: HomePage(),
      image: Image(
        image: AssetImage("assets/trops_logo_866.png"),
      ),
      photoSize: 80,
      loaderColor: Colors.blueAccent,
    );
  }
}