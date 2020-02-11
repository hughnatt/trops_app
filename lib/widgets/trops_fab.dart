
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:trops_app/ui/createAdvert.dart';

class TropsFloatingActionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => CreateAdvertPage()));}
        );
  }
}