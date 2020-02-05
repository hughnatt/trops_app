import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:trops_app/models/Advert.dart';
import 'package:trops_app/ui/common/trops_bottom_bar.dart';
import 'package:trops_app/ui/common/trops_fab.dart';
import 'package:trops_app/ui/detailedAdvert.dart';
import 'package:trops_app/models/User.dart';
import 'package:trops_app/ui/profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Advert> _adverts = new List<Advert>();
  List<String> _categories = [
    "Ski",
    "Surf",
    "Foot",
    "Rugby",
    "Tennis",
    "Basket",
    "Volley",
    "Hand",
    "Badminton",
    "Pétanque",
    "Danse"
  ];

  @override
  void initState(){
    super.initState();
    loadAdverts();
  }

  loadAdverts() async {

    List result = await jsonDecode("[{\"title\":\"Titre de annonce 1\",\"price\":\"10\u20ac\",\"description\":\"Description annonce 1\",\"image\":\"https:\/\/external-content.duckduckgo.com\/iu\/?u=http%3A%2F%2Ficanbecreative.com%2Fres%2FIronMan2%2Firon_man_2_imax_poster-normal.jpg&f=1&nofb=1\"},{\"title\":\"Titre de annonce 2\",\"price\":\"20\u20ac\",\"description\":\"Description annonce 2\",\"image\":\"https:\/\/external-content.duckduckgo.com\/iu\/?u=https%3A%2F%2Fi.ytimg.com%2Fvi%2FRKJTKFdiO5c%2Fmaxresdefault.jpg&f=1&nofb=1\"},{\"title\":\"Titre de annonce 3\",\"price\":\"30\u20ac\",\"description\":\"Description annonce 3\",\"image\":\"https:\/\/external-content.duckduckgo.com\/iu\/?u=https%3A%2F%2Fi.ytimg.com%2Fvi%2FQlt9gzVl3dA%2Fmaxresdefault.jpg&f=1&nofb=1\"},{\"title\":\"Titre de annonce 1\",\"price\":\"10\u20ac\",\"description\":\"Description annonce 1\",\"image\":\"https:\/\/external-content.duckduckgo.com\/iu\/?u=http%3A%2F%2Ficanbecreative.com%2Fres%2FIronMan2%2Firon_man_2_imax_poster-normal.jpg&f=1&nofb=1\"},{\"title\":\"Titre de annonce 2\",\"price\":\"20\u20ac\",\"description\":\"Description annonce 2\",\"image\":\"https:\/\/external-content.duckduckgo.com\/iu\/?u=https%3A%2F%2Fi.ytimg.com%2Fvi%2FRKJTKFdiO5c%2Fmaxresdefault.jpg&f=1&nofb=1\"},{\"title\":\"Titre de annonce 3\",\"price\":\"30\u20ac\",\"description\":\"Description annonce 3\",\"image\":\"https:\/\/external-content.duckduckgo.com\/iu\/?u=https%3A%2F%2Fi.ytimg.com%2Fvi%2FQlt9gzVl3dA%2Fmaxresdefault.jpg&f=1&nofb=1\"},{\"title\":\"Titre de annonce 1\",\"price\":\"10\u20ac\",\"description\":\"Description annonce 1\",\"image\":\"https:\/\/external-content.duckduckgo.com\/iu\/?u=http%3A%2F%2Ficanbecreative.com%2Fres%2FIronMan2%2Firon_man_2_imax_poster-normal.jpg&f=1&nofb=1\"},{\"title\":\"Titre de annonce 2\",\"price\":\"20\u20ac\",\"description\":\"Description annonce 2\",\"image\":\"https:\/\/external-content.duckduckgo.com\/iu\/?u=https%3A%2F%2Fi.ytimg.com%2Fvi%2FRKJTKFdiO5c%2Fmaxresdefault.jpg&f=1&nofb=1\"},{\"title\":\"Titre de annonce 3\",\"price\":\"30\u20ac\",\"description\":\"Description annonce 3\",\"image\":\"https:\/\/external-content.duckduckgo.com\/iu\/?u=https%3A%2F%2Fi.ytimg.com%2Fvi%2FQlt9gzVl3dA%2Fmaxresdefault.jpg&f=1&nofb=1\"}]");

    setState(() {

      result.forEach((item){

        var advert = new Advert(
          item["title"],
          item["price"],
          item["description"],
          item["image"]
        );

        _adverts.add(advert);

      });
    });
  }

  Widget _getListViewWidget(){
    var list = ListView.builder(
      itemCount: _adverts.length,
      padding: EdgeInsets.only(top: 5.0),
      itemBuilder: (context, index) {
        return GestureDetector(
          child: Container(
            margin: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 0),
            child: Material(
              borderRadius: BorderRadius.circular(10.0),
              elevation: 2.0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), bottomLeft: Radius.circular(10.0)),
                    child: FadeInImage.assetNetwork(
                      placeholder: "assets/Rolling-1s-200px.gif",
                      image: _adverts[index].getImage(),
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  _getTextColumWidget(_adverts[index].getTitle(), _adverts[index].getPrice().toString(), _adverts[index].getDescription())
                ],
              ),
            ),
          ),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder : (context) => DetailedAdvertPage(advert : _adverts[index]))),
        );
      },
    );

    return list;

  }

  Widget _getTitleWidget(String title){
    return Text(
      title,
      maxLines: 1,
      style: TextStyle(
          fontWeight: FontWeight.bold
      ),
    );
  }


  Widget _getPriceWidget(String price){
    return Text(
      price,
      maxLines: 1,
      style: TextStyle(
          color: Colors.orange
      ),
    );
  }

  Widget _getDescriptionWidget(String description){
    return Text(
      description,
      maxLines: 3,
    );
  }

  Widget _getTextColumWidget(String title, String price, String description){
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _getTitleWidget(title),
          _getPriceWidget(price),
          _getDescriptionWidget(description)
        ],
      ),
    );
  }

  Widget _getListCategories(){

    ListView _listCategories = ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        return _categoryItemWidget(index);
      }
    );

    return Container(
      child: _listCategories,
    );
  }

  Widget _categoryItemWidget(index) {

    return Center(
      child: Padding(
        padding: EdgeInsets.only(left: 10),
        child: RaisedButton(
          onPressed: () {},
          color: Colors.blue,
          textColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: Text(_categories[index]),
        ),
      ),
    );

  }

  @override
  Widget build(BuildContext context) {

    Widget searchBar = Container(
      padding: new EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 0),
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
                    onTap: ()  => Navigator.pushNamed(context, "/search"),
                    readOnly: true,
                  )
              )
            ],
          ),
        ),
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            searchBar,
            SizedBox(
              height: 50,
              child: _getListCategories(),
            ),
            Expanded(
              child: _getListViewWidget(),
            )
          ],
        ),
      ),


      bottomNavigationBar: TropsBottomAppBar(),
      floatingActionButton: TropsFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
