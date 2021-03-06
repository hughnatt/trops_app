import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trops_app/utils/session.dart';

class TropsFloatingActionButton extends StatelessWidget {

  void _onButtonPressed(BuildContext context){
    if(Session.isAuthenticated){
      Navigator.pushNamed(context, "/create");
    } else if (ModalRoute.of(context).settings.name != "/auth"){
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