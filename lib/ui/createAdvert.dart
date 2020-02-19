import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trops_app/api/category.dart';
import 'package:trops_app/api/data.dart';
import 'package:trops_app/models/DateRange.dart';
import 'package:trops_app/api/image.dart';
import 'package:trops_app/models/User.dart';
import 'package:trops_app/models/TropsCategory.dart';
import 'package:trops_app/widgets/trops_bottom_bar.dart';
import 'package:trops_app/utils/imagesManager.dart';
import 'package:trops_app/widgets/advertField.dart';
import 'package:intl/intl.dart';

String _selectedCategoryID;

class CreateAdvertPage extends StatefulWidget {

  @override
  _CreateAdvertPage createState() => _CreateAdvertPage();
}

enum SourceType {gallery, camera} //enum for the different sources of the images picked by the user
enum ResultType {success, failure, denied} //enum for the different case of the creation of an advert



class _CreateAdvertPage extends State<CreateAdvertPage> {

  List<DateRange> _availability = new List<DateRange>();
  ImagesManager _imagesManager = ImagesManager(); //Object that allow us to load 4 images for the current advert that will be created
  TextEditingController _titleController = TextEditingController(); //controller to get the text form the title field
  TextEditingController _descriptionController = TextEditingController(); //controller to get the text form the description field
  TextEditingController _priceController = TextEditingController(); //controller to get the text form the price field

  List<TropsCategory> _categories = new List<TropsCategory>();

  @override
  void initState(){
    super.initState();
    loadCategories();
    setState(() {
      _availability.add(DateRange(DateTime.now(), DateTime.now()));
    });
  }

  loadCategories() async {

    getCategories().then( (List<TropsCategory> res) {
      setState(() {
        _categories = res;
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


  void _imageUploadProcess(SourceType source, int index) async {
    var picture = await _openSource(context, index, source); //return the file choosen by the user

    var compressedPicture = await this._imagesManager.compressAndGetFile(picture);

    this.setState((){
      _imagesManager.loadFile(index, compressedPicture); //add the file to the imageMangaer
    });

    uploadImage(compressedPicture); //compress & upload the image on server
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
              _imageUploadProcess(SourceType.gallery, index);
              Navigator.of(context).pop(); //we make the alert dialog disapear
            },
          ),
          ListTile(
            leading: Icon(Icons.photo_camera),
            title: Text("Prendre une photo"),
            onTap: () {
              _imageUploadProcess(SourceType.camera, index);
              Navigator.of(context).pop(); //we make the alert dialog disapear
            },
          ),
          ListTile(
            enabled: (_imagesManager.get(index) != null), //the user can't delete the picture if the image at index is null
            leading: Icon(Icons.delete),
            title: Text("Supprimer la photo"),
            onTap: () {
              _deleteImageProcess(context, index);
              Navigator.of(context).pop(); // we close the alertDialog
            },
          )
        ],
      );
    });
  }

  _deletePicture(BuildContext context, int index){
    this.setState(() { //we reload the UI
      _imagesManager.removeAt(index);
    });
  }

  void _deleteImageProcess(BuildContext context, int index) async{
    var response = await deleteImage(_imagesManager.get(index));//First, delete the image from the server

    if(response.statusCode == 200){//if the deletion is a success
      _deletePicture(context, index); //we delete the image in client + refresh UI
    }
    else{
      print("Delete error " + response.statusCode.toString());
    }
  }
  
  bool _isPriceValid = true;
  
  Widget _buildValuePicker() {
    return Container(
      padding: EdgeInsets.only(top: 20,right: 25,left:10,bottom:20),
      child:
      TextField(
        keyboardType: TextInputType.number,
        controller: _priceController,
        inputFormatters: [BlacklistingTextInputFormatter(RegExp("[ ]?[,]?[-]?")),],
        onChanged: (String text) {
          try{
            if(_priceController.text != ""){
              double.parse(_priceController.text);
              setState(() {
                _isPriceValid = true;
              });
            }
          }
          catch(err){
            setState(() {
              _isPriceValid = false;
            });
          }
        },
        decoration: InputDecoration(
          icon: Icon(Icons.euro_symbol),
          hintText: 'Coût de location (par jour)',
          border: InputBorder.none,
          errorText: _isPriceValid ? null : "Format incorrect"
        ),
      ),
    );
  }

  Widget _buildValidationButton(){
    return Container(
      padding: EdgeInsets.only(left:25.0, right: 25.0, bottom: 10.0),
      child: MaterialButton(
        color: Colors.green,
        textColor: Colors.white,
        onPressed: () =>_uploadAdvert(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: Text("Créer l'annonce",style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
      ),
    );
  }


  ///
  ///
  ///
  Future<Null> _selectDate(BuildContext context, int index, bool start) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: start ? DateTime.now() : _availability[index].start,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked.isAfter(DateTime.now())){
      if (start){
        setState(() {
          _availability[index].start = picked;
          if (picked.isAfter(_availability[index].end)){
            _availability[index].end = picked;
          }
        });
      } else {
        setState(() {
          _availability[index].end = picked;
          if (picked.isBefore(_availability[index].start)){
            _availability[index].start = picked;
          }
        });
      }
    }
  }

  Widget _buildAvailabilityList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _availability.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                  "DU  ",
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
              OutlineButton(
                child: Text(
                    DateFormat('dd-MM-yyyy').format(_availability[index].start)
                ),
                onPressed: () {
                  _selectDate(context,index,true);
                },
                textColor: Colors.blueAccent,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
              ),
              Text(
                "  AU  ",
                style: TextStyle(
                  fontWeight: FontWeight.bold
                ),
              ),
              OutlineButton(
                child: Text(
                    DateFormat('dd-MM-yyyy').format(_availability[index].end)
                ),
                onPressed: () {
                  _selectDate(context,index,false);
                },
                textColor: Colors.blueAccent,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10)
              ),
              IconButton(
                icon: Icon(Icons.delete),
                color: Colors.red,
                highlightColor: Colors.deepOrangeAccent,
                onPressed: (_availability.length <= 1) ? null : () {
                  {
                    setState(() {
                      _availability.removeAt(index);
                    });
                  }
                },
              ),
            ],
          ),
        );
      }
    );
  }

  void unfocus(){
    FocusScope.of(context).unfocus(); //make all the textfield loose focus
  }

  Widget _buildPictureGrild() {
    return GridView.count(
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
        );
      }),
    );
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


  bool _checkFields(){
    return (_titleController.text.isNotEmpty && _priceController.text.isNotEmpty && _selectedCategoryID != ""); //check if all REQUIRED field have a value
  }


  void _uploadAdvert() async {

    this.unfocus();

    List<String> splitedPaths = this._imagesManager.getAllFilePath();


    if(_checkFields() && _isPriceValid){ //if the user have correctly completed the form
      var response = await uploadAdvertApi(_titleController.text, double.parse(_priceController.text), _descriptionController.text, _selectedCategoryID, User.current.getEmail(),splitedPaths, _availability); // we try to contact the APi to add the advert

      if (response.statusCode != 201){ //if the response is not 201, the advert wasn't created for some reasons
        _showUploadResult(context,ResultType.failure); //we warn the user that the process failed
      }
      else{ // the response is 201, the creation was a sucess
        _showUploadResult(context,ResultType.success); // we warn him that it's a success
      }
    }
    else{ // the user doesn't correctly complete the form
      _showUploadResult(context, ResultType.denied); // we warn him that he can't create the advert
    }

  }

  Future<void> _showUploadResult(BuildContext context, ResultType result) { //one function to show an alertdialog depending of the advert state when user clicked on create
    String title;
    String content;
    int popCount;

    int count = 0;
    Color color;

    switch(result){
      case ResultType.success:
        {
          title = "Opération terminée";
          content = "Votre annonce a été créée avec succès";
          popCount = 2;
          color = Colors.greenAccent;
          break;
        }
      case ResultType.failure:
        {
          title = "Opération échouée";
          content = "Malheureusement, votre annonce n'a pas pu être créée";
          popCount = 1;
          color = Colors.redAccent;
          break;
        }
      case ResultType.denied:
        {
          title = "Pas si vite !";
          content = "Vérifiez que les champs obligatoires soient remplis (Titre, Prix, Catégorie, Dates)";
          popCount = 1;
          color = Colors.redAccent;
          break;
        }

    }
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return WillPopScope(
            onWillPop: () {},
            child : AlertDialog(
              title: new Text(title),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children : <Widget>[
                  Expanded(
                    child:  new Text(
                      content,
                      style: TextStyle(
                        color: color,
                      ),
                    ),
                  )
                ],
              ),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                new FlatButton(
                  child: new Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).popUntil((_) => count++ >= popCount);
                  },
                ),
              ],
            ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.only(top: 25),
                    child: Center(
                      child: Text("Création d'une annonce", style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),),
                    )
                ),

                Container(
                  padding: EdgeInsets.all(25.0),
                  child: Material(
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)
                    ),
                    child: Column(
                      children: <Widget>[
                        AdvertField(nbLines: 1,label:"Nom du produit",icon: Icons.title,controller: _titleController),
                        Container(
                          width: 250.0,
                          height: 1.0,
                          color: Colors.grey[400],
                        ),
                        _buildValuePicker(),
                      ],
                    ),
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(left:25.0, right: 25.0, bottom: 25.0),
                  child: Material(
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)
                    ),
                    //child: AdvertField(nbLines: 3,label: "Description",icon: Icons.description,controller: _descriptionController),
                    child: Container(
                      padding: EdgeInsets.only(top: 25,right: 25, left:10, bottom: 20.0),
                      child: TextField(
                        controller: _descriptionController,
                        maxLines: null,
                        maxLength: 1000,
                        decoration: InputDecoration(
                          icon: Icon(Icons.description),
                          hintText: "Description",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(left:25.0, right: 25.0, bottom: 25.0),
                  child: Material(
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)
                    ),
                    child: Container(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                                "Catégorie",
                                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)
                            ),
                            CategorySelector(categories: _categories),
                          ],
                        )
                    ),
                  ),
                ),

                Container(
                    padding: EdgeInsets.only(left:25.0, right: 25.0, bottom: 25.0),
                    child: Material(
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)
                        ),
                        child: Container(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              children: <Widget>[
                                Text(
                                    "Disponibilités",
                                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)
                                ),
                                _buildAvailabilityList(),
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                ),
                                RaisedButton.icon(
                                  label: Text("Ajouter une période"),
                                  icon: Icon(Icons.add),
                                  textColor: Colors.blueAccent,
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _availability.add(DateRange(DateTime.now(), DateTime.now()));
                                    });
                                  },
                                ),
                              ],
                            )
                        )
                    )
                ),

                Container(
                  padding: EdgeInsets.only(top: 20.0, left:25.0, right: 25.0, bottom: 10.0),
                  child: Material(
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(10.0),
                          child: Text("Photos", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                        ),
                        _buildPictureGrild()
                      ],
                    ),
                  ),
                ),

                Container(
                    padding: EdgeInsets.only(top:25,bottom:25),
                    child: _buildValidationButton()
                ),
              ],
            ),
          ),
        )
      ),
      bottomNavigationBar: TropsBottomAppBar(),
    );
  }


}

class CategorySelector extends StatefulWidget {

  final List<TropsCategory> categories;
  CategorySelector({Key key, this.categories}) : super(key: key);

  @override
  _CategorySelectorState createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector>{


  Widget _buildTiles(TropsCategory root){
    if (root.subcategories.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(left:20, right: 5),
        child: Row(
          children: <Widget>[
            Text(root.title),
              Spacer(),
              Radio<String>(
                value: root.id,
                groupValue: _selectedCategoryID,
                onChanged: (String value){
                  setState(() {
                    _selectedCategoryID = value;
                  });
                },
            )
          ],
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
          ],
        ),
        children: root.subcategories.map(_buildTiles).toList(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) =>_buildTiles(widget.categories[index]),
      itemCount: widget.categories.length,
    );
  }
}