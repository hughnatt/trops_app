import 'package:flutter/material.dart';
import 'package:trops_app/ui/profile.dart';
import 'package:trops_app/models/User.dart';

class TropsBottomAppBar extends StatelessWidget {
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
            IconButton(icon: Icon(Icons.home), onPressed : () {Navigator.pushNamed(context, "/");}),
            IconButton(icon: Icon(Icons.search), onPressed: () {Navigator.pushNamed(context, "/search");},),
            SizedBox(width: 40), // The dummy child
            IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
            IconButton(icon: Icon(Icons.account_circle), onPressed: ()
            {
              if (User.current != null)
              {
                Navigator.push(context, MaterialPageRoute(builder : (context) => ProfilePage(user : User.current)));
              } else {
                Navigator.pushNamed(context, "/auth");
              }
            }),
            SizedBox(width: 1),
          ],
        ),
      ),
    );;
  }

}