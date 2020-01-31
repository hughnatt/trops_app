import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key key}) : super(key : key);

  @override
  _ProfilePageState createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage>{

  bool _isFabVisible = true;
  NotchedShape _bottomBarShape = CircularNotchedRectangle();

  void _toggleFabVisibility(){
    setState(() {
      if (_isFabVisible){
        _isFabVisible = false;
        _bottomBarShape = null;
      } else {
        _isFabVisible = true;
        _bottomBarShape = CircularNotchedRectangle();
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Center(
          child: ProfileOverview(),
        ),
        floatingActionButton: Visibility(
          visible: _isFabVisible,
          child: FloatingActionButton(
            child: Icon(Icons.search),
            onPressed: () {},
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
            shape: _bottomBarShape,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(width: 1),
                IconButton(icon: Icon(Icons.home), onPressed : _toggleFabVisibility),
                IconButton(icon: Icon(Icons.search), onPressed: () {},),
                SizedBox(width: 40), // The dummy child
                IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
                IconButton(icon: Icon(Icons.message), onPressed: () {}),
                SizedBox(width: 1),
              ],
            )
        )

    );
  }
}


class ProfileOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
              "Nom d'utilisateur",
              textAlign: TextAlign.left,
              textScaleFactor: 2.0,
              style: TextStyle(fontWeight: FontWeight.bold)
          ),
          Text(
            "Email",
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}