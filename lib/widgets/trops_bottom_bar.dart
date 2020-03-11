import 'package:flutter/material.dart';
import 'package:trops_app/ui/profile.dart';
import 'package:trops_app/models/User.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:trops_app/utils/session.dart';

class TropsBottomAppBar extends StatelessWidget {

  void _onHomePressed(BuildContext context){

    if(ModalRoute.of(context).settings.name != "/"){
      Navigator.pushNamed(context, "/");
    }

  }

  void _onSearchPressed(BuildContext context){
    if(ModalRoute.of(context).settings.name != "/search"){
      Navigator.pushNamed(context, "/search");
    }
  }

  void _onNotificationsPressed(BuildContext context){

  }

  void _onProfilePressed(BuildContext context){
    if (Session.isAuthenticated)
    {
      if(ModalRoute.of(context).settings.name != "/profile"){
        Navigator.pushNamed(context, "/profile", arguments: Session.currentUser);
      }

    } else if(ModalRoute.of(context).settings.name != "/auth"){
      Navigator.pushNamed(context, "/auth", arguments: "/profile");
    }
  }

  Color _whatColorToPaint(BuildContext context, String path){
    if(ModalRoute.of(context).settings.name == path){
      return Colors.blue;
    } else {
      return Colors.black54;
    }
  }

  Color _whatColorToPaintProfile(BuildContext context){
    if(ModalRoute.of(context).settings.name == "/auth" || ModalRoute.of(context).settings.name == "/profile"){
      return Colors.blue;
    } else {
      return Colors.black54;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      child: Container(
        height: 50.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(width: 1),
            IconButton(icon: Icon(Icons.home,size: 30,color: _whatColorToPaint(context, "/"),), onPressed: () => _onHomePressed(context),),
            IconButton(icon: Icon(Icons.search,size: 30,color: _whatColorToPaint(context, "/search")), onPressed: () => _onSearchPressed(context),),
            SizedBox(width: 40), // The dummy child
            IconButton(icon: Icon(FontAwesomeIcons.bell,color: _whatColorToPaint(context, "")), onPressed: () => _onNotificationsPressed(context),),
            IconButton(icon: Icon(FontAwesomeIcons.user,color: _whatColorToPaintProfile(context)), onPressed: ()=> _onProfilePressed(context),),
            SizedBox(width: 1),
          ],
        ),
      ),
    );
  }

}