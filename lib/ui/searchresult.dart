import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:trops_app/models/advert.dart';

class SearchResultPage extends StatefulWidget {

  SearchResultPage({Key key}) : super(key: key);


  @override
  _SearchResultPageState createState() => _SearchResultPageState();

}

class _SearchResultPageState extends State<SearchResultPage>{

  List<Advert> _adverts = new List<Advert>();

  @override
  void initState(){
    super.initState();
    loadAdverts('');
  }


  loadAdverts(String query) {

    List result = jsonDecode("[{\"title\":\"iron man\",\"price\":\"10\u20ac\",\"description\":\"Description annonce 1\",\"image\":\"https:\/\/external-content.duckduckgo.com\/iu\/?u=http%3A%2F%2Ficanbecreative.com%2Fres%2FIronMan2%2Firon_man_2_imax_poster-normal.jpg&f=1&nofb=1\"},{\"title\":\"Titre de annonce 2\",\"price\":\"20\u20ac\",\"description\":\"Description annonce 2\",\"image\":\"https:\/\/external-content.duckduckgo.com\/iu\/?u=https%3A%2F%2Fi.ytimg.com%2Fvi%2FRKJTKFdiO5c%2Fmaxresdefault.jpg&f=1&nofb=1\"},{\"title\":\"Titre de annonce 3\",\"price\":\"30\u20ac\",\"description\":\"Description annonce 3\",\"image\":\"https:\/\/external-content.duckduckgo.com\/iu\/?u=https%3A%2F%2Fi.ytimg.com%2Fvi%2FQlt9gzVl3dA%2Fmaxresdefault.jpg&f=1&nofb=1\"},{\"title\":\"Titre de annonce 1\",\"price\":\"10\u20ac\",\"description\":\"Description annonce 1\",\"image\":\"https:\/\/external-content.duckduckgo.com\/iu\/?u=http%3A%2F%2Ficanbecreative.com%2Fres%2FIronMan2%2Firon_man_2_imax_poster-normal.jpg&f=1&nofb=1\"},{\"title\":\"Titre de annonce 2\",\"price\":\"20\u20ac\",\"description\":\"Description annonce 2\",\"image\":\"https:\/\/external-content.duckduckgo.com\/iu\/?u=https%3A%2F%2Fi.ytimg.com%2Fvi%2FRKJTKFdiO5c%2Fmaxresdefault.jpg&f=1&nofb=1\"},{\"title\":\"Titre de annonce 3\",\"price\":\"30\u20ac\",\"description\":\"Description annonce 3\",\"image\":\"https:\/\/external-content.duckduckgo.com\/iu\/?u=https%3A%2F%2Fi.ytimg.com%2Fvi%2FQlt9gzVl3dA%2Fmaxresdefault.jpg&f=1&nofb=1\"},{\"title\":\"Titre de annonce 1\",\"price\":\"10\u20ac\",\"description\":\"Description annonce 1\",\"image\":\"https:\/\/external-content.duckduckgo.com\/iu\/?u=http%3A%2F%2Ficanbecreative.com%2Fres%2FIronMan2%2Firon_man_2_imax_poster-normal.jpg&f=1&nofb=1\"},{\"title\":\"Titre de annonce 2\",\"price\":\"20\u20ac\",\"description\":\"Description annonce 2\",\"image\":\"https:\/\/external-content.duckduckgo.com\/iu\/?u=https%3A%2F%2Fi.ytimg.com%2Fvi%2FRKJTKFdiO5c%2Fmaxresdefault.jpg&f=1&nofb=1\"},{\"title\":\"hulk\",\"price\":\"30\u20ac\",\"description\":\"Description annonce 3\",\"image\":\"https:\/\/external-content.duckduckgo.com\/iu\/?u=https%3A%2F%2Fi.ytimg.com%2Fvi%2FQlt9gzVl3dA%2Fmaxresdefault.jpg&f=1&nofb=1\"}]");


    setState(() {
      if (_adverts.length > 0) {
        _adverts.removeRange(0, _adverts.length);
      }

      result.forEach((item) {
        var advert = new Advert(
            item["title"],
            item["price"],
            item["description"],
            item["image"]
        );

        if (query != '') {
          if (advert.getTitle().) {
            _adverts.add(advert);
          }
        } else {
          _adverts.add(advert);
        }
      });
    });

  }



  Widget _getListViewWidget(){

    return ListView.builder(
     // key: UniqueKey(),
      itemCount: _adverts.length,
      padding: EdgeInsets.only(top: 5.0),
      itemBuilder: (context, index) {
        return Container(
            //key: UniqueKey(),
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
                      placeholder: "",
                      image: _adverts[index].getImage(),
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  _getTextColumWidget(_adverts[index].getTitle(), _adverts[index].getPrice(), _adverts[index].getDescription())
                ],
              ),
            )
        );
      },
    );

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



  Widget _searchBar(){
    return Container(
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
                        ),
                        border: InputBorder.none),
                    onSubmitted: onSubmitted,
                    onChanged: onSubmitted,
                  ))
            ],
          ),
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[

            _searchBar(),

            SizedBox(height: 10.0,),

            Expanded(
              child: _getListViewWidget(),
            ),

          ],
        ),
      ),
    );
  }

  onSubmitted(query) {
    loadAdverts(query);
    print(_adverts.length);
    print(query);
  }
}

/*class AnnonceCard extends StatefulWidget {
  AnnonceCard({Key key}) : super(key: key);

  @override
  _AnnonceCardState createState() => _AnnonceCardState();
}

class _AnnonceCardState extends State<ColorfulTile> {
  Color myColor;

  @override
  void initState() {
    super.initState();
    myColor = UniqueColorGenerator.getColor();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: myColor,
        child: Padding(
          padding: EdgeInsets.all(70.0),
        ));
  }*/