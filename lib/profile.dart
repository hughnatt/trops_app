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
        body: SingleChildScrollView(
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
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20),
            child : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Icon(Icons.accessibility_new),
                Material(
                  elevation: 4.0,
                  shape: CircleBorder(),
                  clipBehavior: Clip.hardEdge,
                  color: Colors.transparent,
                  child: Ink.image(
                    image: NetworkImage("https://upload.wikimedia.org/wikipedia/commons/thumb/c/c0/Opera_House_and_ferry._Sydney.jpg/220px-Opera_House_and_ferry._Sydney.jpg"),
                    fit: BoxFit.cover,
                    width: 120.0,
                    height: 120.0,
                    child: InkWell(
                      onTap: () {},
                    ),
                  ),
                ),
                Icon(Icons.access_alarms),
              ],
            ),
          ),
         
          Text(
              "Nom d'utilisateur",
              textAlign: TextAlign.center,
              textScaleFactor: 2.0,
              style: TextStyle(fontWeight: FontWeight.bold)
          ),
          Text(
            "Email",
            textAlign: TextAlign.center,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Mes locations",
              textAlign: TextAlign.left,
              textScaleFactor: 1.5,
            ),
          ),
          SizedBox(
            height: 300,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: 15,
              itemBuilder: (BuildContext context, int index) => Card(
                child: Center(child: Image.network("https://upload.wikimedia.org/wikipedia/commons/thumb/c/c0/Opera_House_and_ferry._Sydney.jpg/220px-Opera_House_and_ferry._Sydney.jpg")),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Mes annonces",
              textAlign: TextAlign.left,
              textScaleFactor: 1.5,
            ),
          ),
          SizedBox(
            height: 300,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: 15,
              itemBuilder: (BuildContext context, int index) => Card(
              child: Center(child: Image.network("https://upload.wikimedia.org/wikipedia/commons/thumb/c/c0/Opera_House_and_ferry._Sydney.jpg/220px-Opera_House_and_ferry._Sydney.jpg")),
              ),
            ),
          ),

        ],
      ),
    );
  }
}