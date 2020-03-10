
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:trops_app/ui/createAdvert.dart';
import 'package:trops_app/models/User.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TropsFloatingActionButton extends StatelessWidget {

  void _onButtonPressed(BuildContext context){
    if(User.current != null){
      Navigator.pushNamed(context, "/create");
    } else {
      Navigator.pushNamed(context, "/auth", arguments: "/create");
    }

  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        child: Icon(FontAwesomeIcons.plus),
        onPressed: () => _onButtonPressed(context),
        );
  }
}