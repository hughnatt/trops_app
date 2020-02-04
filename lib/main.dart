import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:trops_app/ui/createAdvert.dart';
import 'package:trops_app/ui/detailedAdvert.dart';
import 'ui/home.dart';

void main() => runApp(TropsApp());

class TropsApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate
        ],
        supportedLocales: [
          const Locale('fr')
        ],
        title: "Trop's",
        home: CreateAdvertPage()
    );
  }

}