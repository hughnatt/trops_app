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
import 'package:trops_app/widgets/imageSelector.dart';

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

  GlobalKey<ImageSelectorState> _imageSelectorState = GlobalKey<ImageSelectorState>(); //GlobalKey to access the imageSelector state

  _AdminAdvertViewState({Key key, @required this.advert,}) ;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: advert.getTitle());
    descriptionController = TextEditingController(text: advert.getDescription());
    priceController = TextEditingController(text: advert.getPrice().toString());
    categorySelector = advert.getCategory();

    for(int i=0;i < advert.getAllImages().length;i++){
      _imageSelectorState.currentState.addLink(i, advert.getAllImages()[i]);
    }

    getCategories().then( (List<TropsCategory> res) {
      setState(() {
        _categories = res;
        categorySelector = advert.getCategory();
      });
    });

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

              ImageSelector(),
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