import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:trops_app/api/category.dart';
import 'package:trops_app/api/search.dart';
import 'package:trops_app/models/Advert.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:trops_app/models/Location.dart';
import 'package:trops_app/models/TropsCategory.dart';
import 'package:trops_app/widgets/advertTile.dart';
import 'package:trops_app/widgets/autocompleteSearch.dart';
import 'package:trops_app/widgets/trops_scaffold.dart';

class SearchResultPage extends StatefulWidget {

  final List<String> preSelectedCategories;
  SearchResultPage({this.preSelectedCategories, Key key}) : super(key: key);


  @override
  _SearchResultPageState createState() => _SearchResultPageState();

}

Map<String,bool> _categorySelected = Map<String,bool>();

class _SearchResultPageState extends State<SearchResultPage>{
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  List<Advert> _adverts = new List<Advert>();

  List<DateTime> picked;

  TextEditingController _keywordController = TextEditingController();
  TextEditingController _priceMinController = TextEditingController();
  TextEditingController _priceMaxController = TextEditingController();
  RangeValues _priceRange = RangeValues(0.0,1.0);

  static const int PRICE_MAX = 500;
  static const int PRICE_MIN = 0;

  static const String DEFAULT_CITY = "Toute la France";
  static const int DEFAULT_DISTANCE = 5;

  String _city = DEFAULT_CITY;
  int _distance = DEFAULT_DISTANCE;
  Location _selectedLocation;

  List<TropsCategory> _categories = List<TropsCategory>();

  @override
  void initState(){
    super.initState();
    loadCategories();
    loadAdverts();
  }

  void _resetCategories(List<TropsCategory> catList){
    for (TropsCategory cat in catList){
      _categorySelected[cat.id] = false;
      if (cat.subcategories.isNotEmpty){
        _resetCategories(cat.subcategories);
      }
    }
  }

  void loadCategories() async {
    getCategories().then( (List<TropsCategory> res) {
      setState(() {
        _categories = res;
        _resetCategories(_categories);
        if (widget.preSelectedCategories != null){
          widget.preSelectedCategories.forEach((id){
            _categorySelected[id] = true;
            _applyValueToSubcategories(findCategory(_categories, id), true);
            _applyFilters();
          });
        }
      });
    });
  }

  void loadAdverts() async {
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

    List<String> categories = List<String>();
    _categorySelected.forEach((id,selected){
      if (selected){
        categories.add(id);
      }
    });

    getResults(_keywordController.text, priceMin, priceMax, categories, _selectedLocation?.getCoordinates(), _distance).then((res) {
      setState(() {
        _adverts = res;
      });
    });
  }

  String getLocationText(){
    if(_city != DEFAULT_CITY){
      return _city + " (" + _distance.toString()+"km)";
    }
    else{
      return _city;
    }
  }

  Future<void> _showAlert(BuildContext context){

    Autocomplete locationSearchBar = Autocomplete();
    int _selectedDistance = 5;

    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Choisir un lieu"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Material(
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 5.0, right: 5.0),
                      child: locationSearchBar,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 10.0),
                            child: Text("Dans un rayon de : $_selectedDistance km"),
                          ),
                          Slider(
                            value: _selectedDistance.toDouble(),
                            min: 5.0,
                            max: 55.0,
                            divisions: 10,
                            onChanged: (double newValue) {
                              setState(() {
                                _selectedDistance = newValue.round();
                              });
                            },
                          ),
                        ],
                    )
                  )
                ],
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text("Valider"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          },
        );

      }
    ).then((returndata) {
      setState(() {
        try{
          _city = locationSearchBar.getSelectedLocation().getCity();
          _distance = _selectedDistance;
        }
        catch(err){
          _city = DEFAULT_CITY;
          _distance = DEFAULT_DISTANCE;
        }
        _selectedLocation = locationSearchBar.getSelectedLocation();

      });
    });
  }

  Widget _buildResultsList(){
    Widget widgetToShow;
    if (_adverts.length == 0){
      widgetToShow = SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: Center(child:Text("Aucun résultat"),),
        ),
      );
    } else {
      widgetToShow = SliverList(
        delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
            return AdvertTile(
              advert: _adverts[index],
            );
          },
          childCount: _adverts.length,
        ),
      );
    }

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

        widgetToShow,

      ],
    );
  }

  Widget _buildSearchBar(){
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: <Widget>[
          IconButton(
              icon:Icon(Icons.arrow_back),
              onPressed:() => Navigator.pop(context, false)
          ),
          Expanded(
            child: Hero(
              tag: 'heroSearchBar',
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
                    onChanged: (value) => _doSearch(),
                  ),
                ),
              ),
            ),
          ),
        ],
      )
    );
  }

  Widget _buildFiltersDrawer(){
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
              _buildCategorySelector(),
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
                  label: Text(getLocationText()),
                  icon: Icon(Icons.gps_fixed),
                  textColor: Colors.blueAccent,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  onPressed: () => _showAlert(context)
                ),
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
                  onPressed: () => _applyFilters(),
                ),
              ),
              Center(
                child: OutlineButton.icon(
                  label: Text("Réinitialiser les filtres"),
                  icon: Icon(Icons.refresh),
                  textColor: Colors.blueAccent,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  onPressed: () => _resetFilters()
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySelector(){
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) => CategoryTile(category: _categories[index]),
      itemCount: _categories.length,
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

            _buildSearchBar(),

            Expanded(
              child: _buildResultsList(),
            ),

          ],
        ),
      ),

      drawer: Drawer(
        child: _buildFiltersDrawer(),
      ),

    );
  }

  void _onPriceRangeChange(){
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

  void _resetFilters(){
    setState(() {
      _priceMinController.text = PRICE_MIN.toString();
      _priceMaxController.text = PRICE_MAX.toString();
      _priceRange = RangeValues(0.0,1.0);
      _resetCategories(_categories);
      _city = DEFAULT_CITY;
      _distance = DEFAULT_DISTANCE;
      _selectedLocation = null;
    });
  }

  void _applyFilters(){
    _scaffoldKey.currentState.openEndDrawer();
    FocusScope.of(context).unfocus();
    loadAdverts();
  }

  void _doSearch(){
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

void _applyValueToSubcategories(TropsCategory cat, bool value){
  if (cat.subcategories.isNotEmpty){
    for (TropsCategory subCat in cat.subcategories){
      _categorySelected[subCat.id] = value;
      _applyValueToSubcategories(subCat, value);
    }
  }
}

class CategoryTile extends StatefulWidget {

  final TropsCategory category;
  CategoryTile({Key key, this.category}) : super(key: key);

  @override
  _CategoryTileState createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile>{

  Widget _buildTiles(TropsCategory root){
    if (root.subcategories.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(right: 20),
        child: CheckboxListTile(
          title: Text(root.title),
          onChanged: (bool value) {
            setState(() {
              _categorySelected[root.id] = value;
            });
          },
          value: _categorySelected[root.id],
        ),
      );
    } else {
      return ExpansionTile(
        key: PageStorageKey<TropsCategory>(root),
        title: Row(
          children: <Widget>[
            Text(
              root.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16
              ),
            ),
            Spacer(),
            Checkbox(
              onChanged: (bool value) {
                setState(() {
                  _categorySelected[root.id] = value;
                  _applyValueToSubcategories(root, value);
                });
              },
              value: _categorySelected[root.id],
            )
          ],
        ),
        children: root.subcategories.map(_buildTiles).toList(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(widget.category);
  }
}



