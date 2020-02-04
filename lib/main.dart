import 'package:flutter/material.dart';
import 'package:trops_app/createAdvert.dart';
import 'ui/home.dart';

void main() => runApp(TropsApp());

class TropsApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Trop's",
        home: CreateAdvertPage()
    );
  }

}