import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:trops_app/api/data.dart';
import 'package:trops_app/api/search.dart';
import 'package:trops_app/models/Advert.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:trops_app/widgets/advertTile.dart';
import 'package:trops_app/widgets/trops_scaffold.dart';

class SearchResultPage extends StatefulWidget {

  SearchResultPage({Key key}) : super(key: key);


  @override
  _SearchResultPageState createState() => _SearchResultPageState();

}

class _SearchResultPageState extends State<SearchResultPage>{
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  List<Advert> _adverts = new List<Advert>();

  String cat = "Catégorie";

  List<DateTime> picked;

  List<String> _categories = [];

  TextEditingController _keywordController = TextEditingController();
  TextEditingController _priceMinController = TextEditingController();
  TextEditingController _priceMaxController = TextEditingController();
  String _dropdownValue;
  RangeValues _priceRange = RangeValues(0.0,1.0);

  static const int PRICE_MAX = 500;
  static const int PRICE_MIN = 0;

  @override
  void initState(){
    super.initState();
    loadCategories();
  }

  loadCategories() async {

    getCategories().then( (List<String> res) {
      setState(() {
        _categories = res;
      });
    });
  }

  loadAdverts() async {
    var priceMin;
    var priceMax;
    try {
      priceMin = int.parse(_priceMinController.text);
      priceMax = int.parse(_priceMaxController.text);
      if (priceMin < 0 || priceMax < priceMin){
        throw Exception();
      }
    } catch(ex){
      priceMin = 0;
      priceMax = 10000;
    }

    print(priceMin);
    print(priceMax);

    getResults(_keywordController.text, priceMin, priceMax, "").then((res) {
      setState(() {
        _adverts = res;
      });
    });
  }

  /*loadAdverts(String query) {

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
  }*/

  Widget _getListViewWidget(){
    if (_adverts.length == 0){
      return Center(
        child: Text(
          "Aucun résultat",
        ),
      );
    } else {
      return CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            title: Center(
              child: FlatButton.icon(
                icon: Icon(Icons.filter_list),
                label: Text("Filtres"),
                onPressed: () {_scaffoldKey.currentState.openDrawer();},
              ),
            ),
            snap: true,
            floating: true,
            backgroundColor: Colors.white,
            expandedHeight: 30,
          ),

          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return AdvertTile(
                  advert: _adverts[index],
                );
              },
            ),
          ),

          /*ListView.builder(
            // key: UniqueKey(),
            itemCount: _adverts.length,
            padding: EdgeInsets.only(top: 5.0),
            itemBuilder: (context, index) {
              return AdvertTile(
                advert: _adverts[index],
              );
            },
          ),*/
        ],
      );

    }


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
                  controller: _keywordController,
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

/*
  double _advancedResearchBarHeight(){
    var usableHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom - 150;
    if (usableHeight < 250) {
      return usableHeight;
    } else {
      return 250;
    }
  }
*/
/*
  Widget _advancedResearchBar(){
    return ExpansionTile(
      title: Text("Recherche Avancée"),
      children: <Widget>[
        Container(
          height: _advancedResearchBarHeight(),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(10),
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
                    }).toList(),
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
                      child: Text("Choisir la disponibilité")
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
              ),
            ),
          ),
        ),
      ],
    );
  }
*/

  Widget _filtersDrawer(){
    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Text(
                "Filtres",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              TextField(
                controller: _keywordController,
                decoration: InputDecoration(
                  hintText: "Mots-clés",
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0),
              ),
              Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(right: 10.0),
                    child: Icon(Icons.list, color: Colors.black54,),
                  ),
                  Flexible(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        hint: Text("Choisir une catégorie"),
                        value: _dropdownValue,
                        isExpanded: true,
                        items: _categories.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String newvalue) {
                          setState(() {
                            _dropdownValue = newvalue;
                          });
                        },
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
              ),
              Row(
                children: <Widget>[
                  Text (
                    "Prix minimal",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Spacer(
                  ),
                  Expanded(
                    child: TextField(
                        controller: _priceMinController,
                        onSubmitted: (value) => _onPriceRangeChange(),
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                            fontWeight: FontWeight.bold
                        )
                    ),
                  ),
                  Text (
                    "€",
                  ),
                ],
              ),

              Padding(
                padding: EdgeInsets.only(top: 10),
              ),
              Row(
                children: <Widget>[
                  Text (
                    "Prix maximal",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Spacer(
                  ),
                  Expanded(
                    child: TextField(
                      controller: _priceMaxController,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                      onSubmitted: (value) => _onPriceRangeChange(),
                    ),
                  ),
                  Text (
                    "€",
                  ),
                ],
              ),

              Padding(
                padding: EdgeInsets.only(top: 10),
              ),
              RangeSlider(
                values: _priceRange,
                onChanged: (RangeValues values){
                  setState(() {
                    _priceRange = values;
                    _priceMinController.text = (_priceRange.start * PRICE_MAX).toInt().toString();
                    _priceMaxController.text = (_priceRange.end * PRICE_MAX).toInt().toString();
                  });
                },

              ),
              /*MaterialButton(
                  color: Colors.blueAccent,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  onPressed: _pickDateTime,
                  child: Text("Choisir la disponibilité")
              ),*/

              Padding(
                padding: EdgeInsets.only(top: 10),
              ),

              Center(
                child: RaisedButton.icon(
                  label: Text("Appliquer"),
                  icon: Icon(Icons.search),
                  textColor: Colors.blueAccent,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  onPressed: () {onAdvancedSubmitted();_scaffoldKey.currentState.openEndDrawer();},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TropsScaffold(
      scaffoldKey: _scaffoldKey,

      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[

            _searchBar(),

            /*FlatButton.icon(
              icon: Icon(Icons.filter_list),
              label: Text("Filtres"),
              onPressed: () {_scaffoldKey.currentState.openDrawer();},
            ),*/

            Expanded(
              child: _getListViewWidget(),
            ),

          ],
        ),
      ),

      drawer: Drawer(
        child: _filtersDrawer(),
      ),

    );
  }

  _onPriceRangeChange(){
    var _priceMin;
    try {
      _priceMin = int.parse(_priceMinController.text);
      if (_priceMin < PRICE_MIN) {
        throw Exception();
      }
    } catch (ex){
      _priceMin = PRICE_MIN;
    }

    var _priceMax;
    try {
      _priceMax = int.parse(_priceMaxController.text);
      if (_priceMax > PRICE_MAX) {
        throw Exception();
      }
    } catch (ex){
      _priceMax = PRICE_MAX;
    }

    if (_priceMin <= _priceMax){
      setState(() {
        _priceRange = RangeValues(_priceMin/PRICE_MAX,_priceMax/PRICE_MAX);
      });
    } else {
      setState(() {
        _priceRange = RangeValues(0.0,1.0);
        _priceMinController.text = "";
        _priceMaxController.text = "";
      });
    }
  }

  onSubmitted(query) async {
    loadAdverts();
  }

  onAdvancedSubmitted(){
    /*if(cat=="Catégorie"){
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
      print(_keywordController.text);
      //Navigator.pop(_ScaffoldKey.currentContext);
    }*/
    FocusScope.of(context).unfocus();
    loadAdverts();
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