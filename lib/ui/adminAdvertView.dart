import 'package:flutter/material.dart';
import 'package:trops_app/api/advert.dart';
import 'package:trops_app/models/Advert.dart';
import 'package:trops_app/models/Location.dart';
import 'package:http/http.dart' as Http;
import 'package:trops_app/models/TropsCategory.dart';
import 'package:trops_app/api/category.dart';
import 'package:trops_app/utils/session.dart';
import 'package:trops_app/widgets/availabilityList.dart';
import 'package:trops_app/widgets/categorySelector.dart';
import 'package:trops_app/widgets/imageSelector.dart';
import 'package:trops_app/widgets/autocompleteSearch.dart';

class AdminAdvertView extends StatefulWidget {
  final Advert advert;

  const AdminAdvertView({Key key, @required this.advert}) : super(key : key);

  _AdminAdvertViewState createState() => _AdminAdvertViewState();
}

enum SourceType {gallery, camera} //enum for the different sources of the images picked by the user

class _AdminAdvertViewState extends State<AdminAdvertView> {

  List<TropsCategory> _categories = new List<TropsCategory>();

  TextEditingController _titleController;
  TextEditingController _descriptionController;
  TextEditingController _priceController;
  String _categorySelector;
  Location _locationSelector;
  AvailabilityList _availabilityList;

  //List<DateRange> availability = List<DateRange>();

  GlobalKey<ImageSelectorState> _imageSelectorState = GlobalKey<ImageSelectorState>(); //GlobalKey to access the imageSelector state
  GlobalKey<AutocompleteState> _autocompleteState = GlobalKey<AutocompleteState>();
  GlobalKey<CategorySelectorState> _categorySelectorState = GlobalKey<CategorySelectorState>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.advert.getTitle());
    _descriptionController = TextEditingController(text: widget.advert.getDescription());
    _priceController = TextEditingController(text: widget.advert.getPrice().toString());

    _categorySelector = widget.advert.getCategory();
    _locationSelector = widget.advert.getLocation();
    _availabilityList = AvailabilityList(availability: widget.advert.getAvailability(),);


    WidgetsBinding.instance.addPostFrameCallback((_) => loadImages()); //wait the build method to be done (avoid calling currentState on null ImageSelector in loadImages)


    getCategories().then( (List<TropsCategory> res) {
      setState(() {
        _categories = res;
      });
    });

  }


  void loadImages(){
    for(int i=0;i < widget.advert.getAllImages().length;i++){
      _imageSelectorState.currentState.addLink(i, widget.advert.getAllImages()[i]);
    }
  }

  Future<void> _deleteFromDB(BuildContext context) async {

    Http.Response res = await deleteAdvert(widget.advert.getId(), Session.token);

    if(res.statusCode == 202){
      Navigator.pop(context);
      return showDialog<String>(
          context: context,
          builder: (BuildContext context) => SimpleDialog(
            title: Text("Suppression réussie"),
            children: <Widget>[
              Container(
                child: Text(""),
              ),
            ],
          )
      );
    } else {
      return showDialog<String>(
          context: context,
          builder: (BuildContext context) => SimpleDialog(
            title: Text("Echec"),
            children: <Widget>[
              Container(
                child: Text("La suppression a échoué, veuillez réessayer plus tard."),
              ),

            ],
          )
      );
    }

  }

  Future<void> onDeletePressed(BuildContext context){
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Supprimer l'annonce"),
        content: Text("Etes-vous sur de vouloir supprimer l'annonce ?"),
        actions: <Widget>[
          FlatButton(
            child: Text("Supprimer"),
            onPressed: () => Navigator.pop(context, 'delete'),
          ),
          FlatButton(
            child: Text("Annuler"),
            onPressed: () => Navigator.pop(context, 'cancel'),
          )
        ],
      ),
    ).then((returnval){
      if(returnval == 'delete'){
        print("delete");
        _deleteFromDB(context);
      }
    });

  }

  Future<void> onSavePressed(BuildContext context) async {

    String title = _titleController.text;
    String description = _descriptionController.text;
    String price = _priceController.text;

    AdvertUploadStatus advertUploadStatus = await modifyAdvert(title,double.parse(price),description,getIDByCategoryName(_categorySelector),widget.advert.getOwner(),widget.advert.getId(), Session.token,_imageSelectorState.currentState.getAllPaths(),_availabilityList.availability,_locationSelector);

    switch(advertUploadStatus){
    case AdvertUploadStatus.SUCCESS:
      Navigator.pop(context);
      return showDialog<String>(
        context: context,
        builder: (BuildContext context) => SimpleDialog(
          title: Text("Succès"),
          children: <Widget>[
            Column(
              children: <Widget>[
                Text("L'annonce a bien été mise à jour."),
                FlatButton(
                  child: Text("Ok"),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ],
        )
      );
    case AdvertUploadStatus.FAILURE:
      return showDialog<String>(
        context: context,
        builder: (BuildContext context) => SimpleDialog(
          title: Text("Echec"),
          children: <Widget>[
            Column(
              children: <Widget>[
                Text("L'annonce n'a pas été mise à jour, veuillez réessayer plus tard"),
                FlatButton(
                  child: Text("Ok"),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ],
        )
      );
    }
  }

  void updateCategory(BuildContext context){
    String cat = getCategoryNameByID(_categorySelectorState.currentState.selectedCategory());
    if(cat != ""){
      setState(() {
        _categorySelector = cat;
      });
    }
    Navigator.pop(context);
  }

  Future<void> chooseCategory(BuildContext context){
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => SimpleDialog(
        title: Text("Choississez une nouvelle catégorie"),
        children: <Widget>[
          CategorySelector(key: _categorySelectorState,categories: _categories),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                child: Text("Ok"),
                onPressed: () => updateCategory(context),
              ),

              FlatButton(
                child: Text("Annuler"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          )

        ],
      ),
    );
  }

  void updateLocation(BuildContext context){

    if(_autocompleteState.currentState.getSelectedLocation()!=null){
      setState(() {
        _locationSelector = _autocompleteState.currentState.getSelectedLocation();
      });
    }
    Navigator.pop(context);
  }

  Future<void> chooseLocation(BuildContext context,){
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => SimpleDialog(
        title: Text("choisissez une nouvelle location"),
        children: <Widget>[
          Autocomplete(key: _autocompleteState),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                child: Text("Ok"),
                onPressed: () => updateLocation(context),
              ),
              FlatButton(
                child: Text("Annuler"),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Modification de l'annonce"),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[

              ImageSelector(key : _imageSelectorState),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.title),
                  ),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  controller: _titleController,
                ),
              ),

              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    icon: Icon(Icons.insert_drive_file),
                  ),
                  style: TextStyle(fontSize: 18,),
                  controller: _descriptionController,
                ),
              ),

              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.euro_symbol),
                  ),
                  style: TextStyle(fontSize: 18,),
                  keyboardType: TextInputType.number,
                  controller: _priceController,
                ),
              ),


              Container(
                padding: EdgeInsets.all(25),
                child: MaterialButton(
                  color: Colors.white54,
                  child: Text(_categorySelector),
                  onPressed: () => chooseCategory(context),

                ),
              ),

              Container(
                padding: EdgeInsets.all(25),
                child: RaisedButton.icon(
                  color: Colors.white54,
                  icon: Icon(Icons.gps_fixed),
                  label: Text(_locationSelector.getCity()),
                  onPressed: () => chooseLocation(context),

                ),
              ),

              Container(
                padding: EdgeInsets.all(25),
                child: Material(
                  child: _availabilityList,
                ),
              ),

            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomAppBar(
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton.icon(onPressed: () => onSavePressed(context), icon: Icon(Icons.save), label: Text("Enregister")),

              FlatButton.icon(onPressed: () => onDeletePressed(context), icon: Icon(Icons.delete, color: Colors.red,), label: Text("Supprimer")),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose(){
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

}