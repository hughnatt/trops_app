import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:trops_app/ui/common/trops_bottom_bar.dart';

class CreateAdvertPage extends StatefulWidget {

  @override
  _CreateAdvertPage createState() => _CreateAdvertPage();
}

class _CreateAdvertPage extends State<CreateAdvertPage> {


  List<DateTime> picked;
  List<File> imageFiles = List(4);
  int imageIndex = 0;

  _openSource(BuildContext context, int index, String source) async {
    int indexToSave;
    ImageSource sourceChoice;

    switch (source) {
      case "camera":
        {
          sourceChoice = ImageSource.camera;
        }
        break;

      case "gallery":
        {
          sourceChoice = ImageSource.gallery;
        }
        break;
    }

    var picture = await ImagePicker.pickImage(source: sourceChoice);
    this.setState(() {
      if (imageIndex == 4 || index < imageIndex) { //if the user have already load 4 picture or we we want to change one
        indexToSave = index;
      }
      else { //The user haven't load 4 image but choose an index too far (exemple: he clicked on the 3rd picture sample; but the second haven't any loaded picture)
        indexToSave = imageIndex; //the index where put the photo is the first availible in the list
        imageIndex++;
      }
      this.imageFiles[indexToSave] = picture;
    });
    Navigator.of(context).pop();
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
              _openSource(context, index, "gallery");
            },
          ),
          ListTile(
            leading: Icon(Icons.photo_camera),
            title: Text("Prendre une photo"),
            onTap: () {
              _openSource(context, index, "camera");
            },
          ),
          ListTile(
            leading: Icon(Icons.delete),
            title: Text("Supprimer la photo"),
            onTap: () {
              print("Not yet implemented");
            },
          )
        ],
      );
    });
  }

  Widget _buildMultilineTextField(int nbLines, String label,
      IconData iconName) {
    return Container(
        padding: EdgeInsets.only(top: 25,right: 25, left:10, bottom: 20.0),
        child: TextField(
            maxLines: nbLines,
            decoration: InputDecoration(
              icon: Icon(iconName),
              hintText: label,
              border: InputBorder.none,
            )
        )
    );
  }

  Widget _buildValuePicker() {
    return Container(
      padding: EdgeInsets.only(top: 20,right: 25,left:10,bottom:20),
      child:
      TextField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          icon: Icon(Icons.euro_symbol),
          hintText: 'Coût de location (par jour)',
          border: InputBorder.none,
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
        onPressed: () {},
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: Text("Créer l'annonce"),
      ),
    );
  }

  Widget _buildDateButton() {
    return MaterialButton(
        color: Colors.blueAccent,
        textColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        onPressed: () => _pickDateTime(),
        child: new Text("Choisir la disponibilité")
    );
  }

  void _pickDateTime() async{
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
    if (imageFiles[index] == null) {
      return Icon(
        Icons.photo_camera,
        size: 50,
      );
    }
    else {
      return Image.file(imageFiles[index], fit: BoxFit.cover);
    }
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     backgroundColor: Colors.white,
     body: ListView(
       scrollDirection: Axis.vertical,
       shrinkWrap: true,
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
                _buildMultilineTextField(1, "Nom du produit", Icons.title),
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
            child: _buildMultilineTextField(4, "Description", Icons.description),
          ),
        ),

        Container(
          padding: EdgeInsets.only(left:25.0, right: 25.0, bottom: 25.0),
          child: _buildDateButton()
        ),

        Container(
          padding: EdgeInsets.only(left:25.0, right: 25.0, bottom: 10.0),
          child: Material(
            elevation: 2.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)
            ),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: Text("Ajouter des photos", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                ),
                _buildPictureGrild()
              ],
            ),
          ),
        ),
          Container(
            padding: EdgeInsets.only(top:25),
             child: _buildValidationButton()
         ),
       ],
     ),
       bottomNavigationBar: TropsBottomAppBar(),
     );
  }
}