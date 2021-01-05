import 'package:flutter/material.dart';
import 'package:http/http.dart' as Http;
import 'package:trops_app/core/data/advert_repository.dart';
import 'package:trops_app/core/data/category_repository.dart';
import 'package:trops_app/core/data/location_repository.dart';
import 'package:trops_app/core/entity/advert.dart';
import 'package:trops_app/core/entity/advert_upload_status.dart';
import 'package:trops_app/core/entity/location.dart';
import 'package:trops_app/core/entity/trops_category.dart';
import 'package:trops_app/ui/widgets/availabilityList.dart';

import 'widgets/autocompleteSearch.dart';
import 'widgets/categorySelector.dart';
import 'widgets/imageSelector.dart';

class AdminAdvertView extends StatefulWidget {
  final Advert advert;
  final CategoryRepository categoryRepository;
  final AdvertRepository advertRepository;
  final LocationRepository locationRepository;

  const AdminAdvertView({
    Key key,
    @required this.advert,
    @required this.categoryRepository,
    @required this.advertRepository,
    @required this.locationRepository
  }) : super(key : key);

  _AdminAdvertViewState createState() => _AdminAdvertViewState();
}

enum SourceType { GALLERY, CAMERA } //enum for the different sources of the images picked by the user

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
    _titleController = TextEditingController(text: widget.advert.title);
    _descriptionController = TextEditingController(text: widget.advert.description);
    _priceController = TextEditingController(text: "${widget.advert.price}");
    _categorySelector = widget.advert.category;
    _locationSelector = widget.advert.location;
    _availabilityList = AvailabilityList(availability: widget.advert.availability);

    WidgetsBinding.instance.addPostFrameCallback((_) => loadImages()); //wait the build method to be done (avoid calling currentState on null ImageSelector in loadImages)

    widget.categoryRepository.getCategories().then( (List<TropsCategory> res) {
      setState(() {
        _categories = res;
      });
    });
  }

  void loadImages(){
    for(int i=0;i < widget.advert.photos.length;i++){
      _imageSelectorState.currentState.addLink(i, widget.advert.photos[i]);
    }
  }

  Future<void> _deleteFromDB(BuildContext context) async {

    Http.Response res = await widget.advertRepository.deleteAdvert(widget.advert.id);

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

    AdvertUploadStatus advertUploadStatus = await widget.advertRepository.modifyAdvert(
        id: widget.advert.id,
        title: title,
        price: double.parse(price),
        description: description,
        category: widget.categoryRepository.getIDByCategoryName(_categorySelector),
        owner: widget.advert.owner,
        photos: _imageSelectorState.currentState.getAllPaths(),
        availability: _availabilityList.availability,
        location: _locationSelector
    );

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
    String cat = widget.categoryRepository.getCategoryNameByID(_categorySelectorState.currentState.selectedCategory());
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
          Autocomplete(
            key: _autocompleteState,
            locationRepository: widget.locationRepository,
          ),
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