import 'package:flutter/material.dart';
import 'package:trops_app/ui/auth.dart';
import 'package:trops_app/ui/createAdvert.dart';
import 'package:trops_app/ui/profile.dart';
import 'package:trops_app/ui/searchresult.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:trops_app/ui/splash.dart';
import 'ui/home.dart';

void main() => runApp(TropsApp());

class TropsApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "TROPS",
      initialRoute: "/splash",
      routes: {
        '/' : (context) => HomePage(),
        '/splash' : (context) => SplashPage(),
        '/search' : (context) => SearchResultPage(),
        '/auth' : (context) => AuthPage(),
        '/profile' : (context) => ProfilePage(),
        '/home' : (context) => HomePage(),
        '/create' : (context) => CreateAdvertPage()
      },
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate
      ],
      supportedLocales: [
        const Locale('fr')
      ],
    );
  }
}