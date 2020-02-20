import 'package:flutter/material.dart';
import 'package:trops_app/ui/auth.dart';
import 'package:trops_app/ui/profile.dart';
import 'package:trops_app/ui/searchresult.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'ui/home.dart';

void main() => runApp(TropsApp());

class TropsApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "TROPS",
      initialRoute: "/",
      routes: {
        '/' : (context) => HomePage(),
        '/search' : (context) => SearchResultPage(),
        '/auth' : (context) => AuthPage(),
        '/profile' : (context) => ProfilePage(),
        '/home' : (context) => HomePage(),
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