import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:trops_app/api/api.dart';
import 'package:trops_app/api/data.dart';
import 'package:trops_app/models/Advert.dart';
import 'package:trops_app/models/User.dart';
import 'package:http/http.dart' as Http;
import 'package:trops_app/models/DateRange.dart';
import 'package:trops_app/utils/imagesManager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trops_app/models/TropsCategory.dart';
import 'package:trops_app/api/category.dart';
import 'package:trops_app/widgets/categorySelector.dart';

class AdminAdvertView extends StatefulWidget {
  final Advert advert;

  const AdminAdvertView({Key key, @required this.advert}) : super(key : key);

  @override
  _AdminAdvertViewState createState() {
    return _AdminAdvertViewState(advert: advert);
  }
}

enum SourceType {gallery, camera} //enum for the different sources of the images picked by the user

class _AdminAdvertViewState extends State<AdminAdvertView> {

  final Advert advert;

  List<TropsCategory> _categories = new List<TropsCategory>();

  TextEditingController titleController;
  TextEditingController descriptionController;
  TextEditingController priceController;
  String categorySelector;

  //List<DateRange> availability = List<DateRange>();

  ImagesManager _imagesManager = ImagesManager();

  _AdminAdvertViewState({Key key, @required this.advert,}) ;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: advert.getTitle());
    descriptionController = TextEditingController(text: advert.getDescription());
    priceController = TextEditingController(text: advert.getPrice().toString());
    categorySelector = advert.getCategory();
    advert.getAllImages().forEach((item) {

      DefaultCacheManager().getSingleFile(item).then((res){
        setState(() {
          _imagesManager.add(res);
        });

      });

    });

    getCategories().then( (List<TropsCategory> res) {
      setState(() {
        _categories = res;
        categorySelector = advert.getCategory();
      });
    });

  }

  Future<File> _openSource(BuildContext context, int index, SourceType source) async {

    ImageSource sourceChoice; //object that represent the source form where to pick the imaes

    switch (source) { //we check where to look, depending by the user's choice
      case SourceType.camera:
        {
          sourceChoice = ImageSource.camera;
        }
        break;

      case SourceType.gallery:
        {
          sourceChoice = ImageSource.gallery;
        }
        break;
    }

    var picture = await ImagePicker.pickImage(source: sourceChoice); //we let the user pick the image where he want

    return picture;
  }

  _deletePicture(BuildContext context, int index){
    this.setState(() { //we reload the UI
      _imagesManager.removeAt(index);
    });
  }

  _uploadPicture(int index, SourceType source) async {
    var picture = await _openSource(context, index, source);

    var compressedPicture = await this._imagesManager.compressAndGetFile(picture);

    this.setState((){
      _imagesManager.loadFile(index, compressedPicture);
    });
  }

  Future<void> _showChoiceDialog(BuildContext context, int index) {

    return showDialog(context: context, builder: (BuildContext context) {
      return SimpleDialog(
        title: Text("Que voulez-vous faire ?"),
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.image),
            title: Text("Importer depuis la gallerie"),
            onTap: () {
              _uploadPicture(index, SourceType.gallery);
              Navigator.of(context).pop(); //we make the alert dialog disapear
            },
          ),
          ListTile(
            leading: Icon(Icons.photo_camera),
            title: Text("Prendre une photo"),
            onTap: () {
              _uploadPicture(index, SourceType.camera);
              Navigator.of(context).pop(); //we make the alert dialog disapear
            },
          ),
          ListTile(
            enabled: (_imagesManager.get(index) != null), //the user can't delete the picture if the image at index is null
            leading: Icon(Icons.delete),
            title: Text("Supprimer la photo"),
            onTap: () {
              _deletePicture(context, index);
              Navigator.of(context).pop(); // we close the alertDialog
            },
          )
        ],
      );
    });
  }

  Widget _boxContent(int index) {
    if (_imagesManager.get(index) == null) {
      return Icon(
        Icons.photo_camera,
        size: 50,
      );
    }
    else {
      return Image.file(_imagesManager.get(index), fit: BoxFit.cover);
    }
  }


  Future<void> _deleteFromDB(BuildContext context) async {

    Http.Response res = await deleteAdvert(advert.getId(), User.current.getToken());

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

    String title = titleController.text;
    String description = descriptionController.text;
    String price = priceController.text;

    Http.Response res = await modifyAdvert(title,double.parse(price),description,categorySelector,advert.getOwner(),advert.getId(), User.current.getToken(),advert.getAllImages());

    if(res.statusCode==200){
      Navigator.pop(context);
      return showDialog<String>(
          context: context,
          builder: (BuildContext context) => SimpleDialog(
            title: Text("Succès"),
            children: <Widget>[
              Text("L'annonce a été modifiée avec succès."),

            ],
          )
      );
    } else {
      return showDialog<String>(
          context: context,
          builder: (BuildContext context) => SimpleDialog(
            title: Text("Echec"),
            children: <Widget>[
              Text("L'annonce n'a pas pu être modifiée, veuillez réessayez plus tard."),

            ],
          )
      );
    }

  }

  void updateCategory(BuildContext context, CategorySelector selector){
    setState(() {
      categorySelector = selector.selectedCategory();
    });
    Navigator.pop(context);
  }

  Future<void> chooseCategory(BuildContext context){
    CategorySelector selector = CategorySelector(categories: _categories,);
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => SimpleDialog(
        title: Text("Choississez une nouvelle catégorie"),
        children: <Widget>[
          selector,

          FlatButton(
            child: Text("Ok"),
            onPressed: () => updateCategory(context,selector),
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

              GridView.count(
                physics: const NeverScrollableScrollPhysics(), //prevent the user to scroll on the gridview instead of the list
                crossAxisCount: 2,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: List.generate(4, (index) {
                  return GestureDetector(
                    onTap: () {
                      _showChoiceDialog(context, index);
                    },
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Material(
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      color: Colors.white,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        child: _boxContent(index),
                      ),
                    )
                  ),
                );}),
              ),


              
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  //textAlign: TextAlign.center,

                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  controller: titleController,
                ),
              ),

              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  maxLines: 3,
                  style: TextStyle(fontSize: 18,),
                  controller: descriptionController,
                ),
              ),

              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  style: TextStyle(fontSize: 18,),
                  keyboardType: TextInputType.number,
                  controller: priceController,
                ),
              ),


              Container(
                padding: EdgeInsets.all(25),
                child: MaterialButton(
                  color: Colors.white30,
                  child: Text(getCategoryNameByID(categorySelector)),
                  onPressed: () => chooseCategory(context),

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
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    super.dispose();
  }

}