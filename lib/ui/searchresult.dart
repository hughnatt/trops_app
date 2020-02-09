import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:trops_app/models/Advert.dart';
import 'package:trops_app/ui/detailedAdvert.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;

class SearchResultPage extends StatefulWidget {

  SearchResultPage({Key key}) : super(key: key);


  @override
  _SearchResultPageState createState() => _SearchResultPageState();

}

class _SearchResultPageState extends State<SearchResultPage>{

  List<Advert> _adverts = new List<Advert>();

  String cat = "Catégorie";

  List<DateTime> picked;

  List<String> _categories = ["Catégorie",
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

  TextEditingController _editingController = TextEditingController();


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
          if (advert.getTitle().contains(query)) {
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
        return GestureDetector(
          child: Container(
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
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: <Widget>[
          IconButton(
              icon:Icon(Icons.arrow_back),
              onPressed:() => Navigator.pop(context, false)
          ),
          Expanded(
            child: Material(
              borderRadius: const BorderRadius.all(const Radius.circular(25.0)),
              elevation: 3.0,
              child: Container(
                height: 45.0,
                margin: EdgeInsets.only(left: 16.0, right: 5.0),
                child: new TextField(
                  maxLines: 1,
                  autofocus: true,
                  decoration: new InputDecoration(
                      icon: Icon(
                          Icons.search,
                          color: Theme.of(context).accentColor
                      ),
                      border: InputBorder.none),
                  onSubmitted: onSubmitted,
                  onChanged: onSubmitted,
                ),
              ),
            ),
          ),
        ],
      )
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

            _advancedResearchBar(),

            Expanded(
              child: _getListViewWidget(),
            ),

          ],
        ),
      ),
    );
  }

  onSubmitted(query) async {
    loadAdverts(query);
    //print(_adverts.length);
    //print(query);
  }

  Widget _advancedResearchBar(){
    return ExpansionTile(
      title: Text("Recherche Avancée"),
      children: <Widget>[
            Card(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    /*Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text("Catégorie :"),*/
                    DropdownButton<String>(
                      onChanged: (String newValue) {
                        setState(() {
                          cat = newValue;
                        });
                      },
                        isDense: false,
                        value: cat,
                        isExpanded: true,
                        icon: Icon(Icons.arrow_downward),
                        iconSize: 24,
                        items: _categories
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        })
                            .toList(),

                    ),
                    /*],
                  ),*/

                    SizedBox(
                      height: 10.0,
                    ),

                    TextField(
                      controller: _editingController,
                      style: TextStyle(
                          fontFamily: "WorkSansSemiBold",
                          fontSize: 16.0,
                          color: Colors.black
                      ),
                      decoration: InputDecoration(
                        hintText: "Prix Maximal",
                      ),
                      keyboardType: TextInputType.number,
                    ),

                    SizedBox(
                      height: 10.0,
                    ),
                    
                    MaterialButton(
                      color: Colors.blueAccent,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      onPressed: _pickDateTime,
                      child: new Text("Choisir la disponibilité")
                    ),

                    SizedBox(
                      height: 10.0,
                    ),

                    ButtonBar(
                      alignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                          child: Text("Rechercher"),
                          onPressed: onAdvancedSubmitted,
                        ),
                      ],
                    ),
                  ],
                ) ,
              ),



            ),

      ],
    );
  }

  void _pickDateTime() async {
    DateTime firstDate; //Variable to allow us to reput the dates picked in the date picker if done previously
    DateTime lastDate;

    if(picked != null && picked.first != null && picked.last != null){ //if the user already picked some dates
      firstDate = picked.first; //we will show him the range choose before
      lastDate = picked.last;
    }
    else{
      firstDate = lastDate = DateTime.now(); //else we just show the basic date (today)
    }

    List<DateTime> returnedDates = await DateRagePicker.showDatePicker( //BEFORE,picked was affecter to the result, but if the user tap cancel, picked was loose because replace by NULL
        context: context,
        initialFirstDate: firstDate,
        initialLastDate: lastDate,
        firstDate: DateTime(DateTime.now().year),
        lastDate: DateTime(DateTime.now().year + 5)
    );

    if(returnedDates != null){ //Allow to handle the cancel button that pop the context
      picked = returnedDates;
    }
  }

  onAdvancedSubmitted(){
    print(_editingController.text);
    print(cat);
    print(picked.first.toString());
    print(picked.last.toString());
  }

  dummy(){
    print('yolo');
  }
}