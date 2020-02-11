import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:trops_app/models/Advert.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:trops_app/widgets/advertTile.dart';

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

    List result = jsonDecode("[{\"title\":\"Titre de annonce 1\",\"price\":10,\"description\":\"Description annonce 1\",\"image\":\"https:\/\/external-content.duckduckgo.com\/iu\/?u=http%3A%2F%2Ficanbecreative.com%2Fres%2FIronMan2%2Firon_man_2_imax_poster-normal.jpg&f=1&nofb=1\"},{\"title\":\"Titre de annonce 2\",\"price\":20,\"description\":\"Description annonce 2\",\"image\":\"https:\/\/external-content.duckduckgo.com\/iu\/?u=https%3A%2F%2Fi.ytimg.com%2Fvi%2FRKJTKFdiO5c%2Fmaxresdefault.jpg&f=1&nofb=1\"},{\"title\":\"Titre de annonce 3\",\"price\":20,\"description\":\"Description annonce 3\",\"image\":\"https:\/\/external-content.duckduckgo.com\/iu\/?u=https%3A%2F%2Fi.ytimg.com%2Fvi%2FQlt9gzVl3dA%2Fmaxresdefault.jpg&f=1&nofb=1\"},{\"title\":\"Titre de annonce 1\",\"price\":10,\"description\":\"Description annonce 1\",\"image\":\"https:\/\/external-content.duckduckgo.com\/iu\/?u=http%3A%2F%2Ficanbecreative.com%2Fres%2FIronMan2%2Firon_man_2_imax_poster-normal.jpg&f=1&nofb=1\"},{\"title\":\"Titre de annonce 2\",\"price\":20,\"description\":\"Description annonce 2\",\"image\":\"https:\/\/external-content.duckduckgo.com\/iu\/?u=https%3A%2F%2Fi.ytimg.com%2Fvi%2FRKJTKFdiO5c%2Fmaxresdefault.jpg&f=1&nofb=1\"},{\"title\":\"Titre de annonce 3\",\"price\":30,\"description\":\"Description annonce 3\",\"image\":\"https:\/\/external-content.duckduckgo.com\/iu\/?u=https%3A%2F%2Fi.ytimg.com%2Fvi%2FQlt9gzVl3dA%2Fmaxresdefault.jpg&f=1&nofb=1\"},{\"title\":\"Titre de annonce 1\",\"price\":10,\"description\":\"Description annonce 1\",\"image\":\"https:\/\/external-content.duckduckgo.com\/iu\/?u=http%3A%2F%2Ficanbecreative.com%2Fres%2FIronMan2%2Firon_man_2_imax_poster-normal.jpg&f=1&nofb=1\"},{\"title\":\"Titre de annonce 2\",\"price\":20,\"description\":\"Description annonce 2\",\"image\":\"https:\/\/external-content.duckduckgo.com\/iu\/?u=https%3A%2F%2Fi.ytimg.com%2Fvi%2FRKJTKFdiO5c%2Fmaxresdefault.jpg&f=1&nofb=1\"},{\"title\":\"Titre de annonce 3\",\"price\":30,\"description\":\"Description annonce 3\",\"image\":\"https:\/\/external-content.duckduckgo.com\/iu\/?u=https%3A%2F%2Fi.ytimg.com%2Fvi%2FQlt9gzVl3dA%2Fmaxresdefault.jpg&f=1&nofb=1\"}]");

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
        return AdvertTile(
          advert: _adverts[index],
        );
      },
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

  Widget _advancedResearchBar(){
    return ExpansionTile(
      title: Text("Recherche Avancée"),
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
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
      ],
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
  }

  onAdvancedSubmitted(){
    if(cat=="Catégorie"){
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: Text("Choississez au minimum la catégorie souhaitée."),
          actions: <Widget>[
            FlatButton(
              child: Text("Ok"),
              onPressed: ()=>Navigator.pop(context),
            ),
          ],
        ),
      );
    } else {
      //send search request to the server
      //Add handling of null value
      print(cat);
      print(picked.first.toString());
      print(picked.last.toString());
      print(_editingController.text);
    }


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

}