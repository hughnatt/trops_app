import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {

    Widget bottomBar = BottomAppBar(
      shape: const CircularNotchedRectangle(),
      child: Container(
        height: 50.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(icon: Icon(Icons.star), onPressed: () {}),
            IconButton(icon: Icon(Icons.star), onPressed: () {}),
            SizedBox(width: 40,),
            IconButton(icon: Icon(Icons.star), onPressed: () {}),
            IconButton(icon: Icon(Icons.star), onPressed: () {}),
          ],
        ),
      ),
    );

    Widget searchBar = Container(
      padding: new EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
      margin: const EdgeInsets.only(),
      child: new Material(
        borderRadius: const BorderRadius.all(const Radius.circular(25.0)),
        elevation: 2.0,
        child: new Container(
          height: 45.0,
          margin: new EdgeInsets.only(left: 16.0, right: 16.0),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Expanded(
                  child: new TextField(
                    maxLines: 1,
                    decoration: new InputDecoration(
                        icon: Icon(
                          Icons.search,
                          color: Theme.of(context).accentColor,
                        ),
                        border: InputBorder.none),
                  ))
            ],
          ),
        ),
      ),
    );



    List<Card> cardBuilder(int length){
      List<Card> cards = List.generate(length, (int index) =>
        Card(
          child: InkWell(
            splashColor: Colors.blue.withAlpha(50),
            onTap: () {},
            child: ListTile(
              leading: Image.network("https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fi.ytimg.com%2Fvi%2FDEMFOeYtrAo%2Fmaxresdefault.jpg&f=1&nofb=1",
                  fit: BoxFit.cover),
              title: Text("Le titre de l'annonce"),
              subtitle: Text("Bonjour, je suis une description sur 2 lignes."),
              isThreeLine: true,
            ),
          ),
        ),
      );
      return cards;
    }

    return Scaffold(
      body: Column(
        children: <Widget>[
          searchBar,
          Expanded(
            child: ListView(
              children: cardBuilder(12),
            ),
          )
        ],
      ),

      bottomNavigationBar: bottomBar,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //Changement de page -> Création d'une nouvelle annonce.
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
