import 'package:flutter/material.dart';
import 'pages/home.dart';

void main() => runApp(TropsApp());

class TropsApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Trop's",
        home: HomePage()
    );
  }

}