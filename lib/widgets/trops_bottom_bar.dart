import 'package:flutter/material.dart';
import 'package:trops_app/ui/profile.dart';
import 'package:trops_app/models/User.dart';

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
    if (User.current != null)
    {
      if(ModalRoute.of(context).settings.name != "/profile"){
        Navigator.pushNamed(context, "/profile", arguments: User.current);
      }

    } else if(ModalRoute.of(context).settings.name != "/auth"){
      Navigator.pushNamed(context, "/auth");
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
            IconButton(icon: Icon(Icons.home), onPressed: () => _onHomePressed(context),),
            IconButton(icon: Icon(Icons.search), onPressed: () => _onSearchPressed(context),),
            SizedBox(width: 40), // The dummy child
            IconButton(icon: Icon(Icons.notifications), onPressed: () => _onNotificationsPressed(context),),
            IconButton(icon: Icon(Icons.account_circle), onPressed: ()=> _onProfilePressed(context),),
            SizedBox(width: 1),
          ],
        ),
      ),
    );
  }

}