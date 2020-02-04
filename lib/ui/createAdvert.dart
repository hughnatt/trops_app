import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/rendering/box.dart';
import 'package:image_picker/image_picker.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;

class CreateAdvertPage extends StatefulWidget {

  @override
  _CreateAdvertPage createState() => _CreateAdvertPage();
}

class _CreateAdvertPage extends State<CreateAdvertPage> {


  List<DateTime> picked;
  List<File> imageFiles = List(4);
  int imageIndex = 0;

  _openSource(BuildContext context, @required int index,
      @required String source) async {
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
      if (imageIndex == 4) {
        indexToSave = index;
      }
      else {
        indexToSave = imageIndex;
        imageIndex++;
      }
      this.imageFiles[indexToSave] = picture;
    });
    Navigator.of(context).pop();
  }

  Future<void> _showChoiceDialog(BuildContext context, int index) {
    return showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        title: Text("How to import picture ?"),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              GestureDetector(
                child: Text("Load picture"),
                onTap: () {
                  _openSource(context, index, "gallery");
                },
              ),

              Padding(padding: EdgeInsets.all(8.0)),
              GestureDetector(
                child: Text("Take picture"),
                onTap: () {
                  _openSource(context, index, "camera");
                },
              )
            ],
          ),
        ),
      );
    });
  }

  Widget _buildMultilineTextField(int nbLines, String label,
      IconData iconName) {
    return Container(
        padding: EdgeInsets.only(top: 50,right: 50),
        child:
        TextField(
            maxLines: nbLines,
            decoration: InputDecoration(
              icon: Icon(iconName),
              labelText: label,
              hintText: 'Type something...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
            )
        )
    );
  }

  Widget _buildValuePicker() {
    return Container(
      padding: EdgeInsets.only(top: 50,right: 50,bottom: 50),
      child:
      TextField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          icon: Icon(Icons.euro_symbol),
          labelText: 'Enter an integer:',
          contentPadding: EdgeInsets.all(10.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
        ),
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
    DateTime firstDate;
    DateTime lastDate;

    if(picked != null && picked.first != null && picked.last != null){
      firstDate = picked.first;
      lastDate = picked.last;
    }
    else{
      picked = List(2);
      firstDate = lastDate = DateTime.now();
    }

    picked = await DateRagePicker.showDatePicker(
        context: context,
        initialFirstDate: firstDate,
        initialLastDate: lastDate,
        firstDate: DateTime(DateTime.now().year),
        lastDate: DateTime(DateTime.now().year + 5)
    );
  }

  Widget _buildPictureGrild() {
    return GridView.count(
      crossAxisCount: 2,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: List.generate(4, (index) {
        return Center(
            child: GestureDetector(
              onTap: () {
                _showChoiceDialog(context, index);
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 3.0),
                ),
                width: 500,
                height: 500,
                child: _boxContent(index),
              ),
            )
        );
      }),
    );
  }

  Widget _boxContent(int index) {
    if (imageFiles[index] == null) {
      return Icon(
        Icons.camera_enhance,
        size: 50,
      );
    }
    else {
      return Image.file(imageFiles[index], fit: BoxFit.cover);
    }
  }

  Widget _buildBottomBar() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      child: Container(
        height: 50.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(width: 1),
            IconButton(icon: Icon(Icons.home), onPressed: () {}),
            IconButton(icon: Icon(Icons.search), onPressed: () {},),
            SizedBox(width: 40), // The dummy child
            IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
            IconButton(icon: Icon(Icons.message), onPressed: () {}),
            SizedBox(width: 1),
          ],
        ),
      ),
    );
  }


//@override
//  Widget build(BuildContext context) {
//
//    return Scaffold(
//        body:
//          SafeArea(
//            child:
//              DefaultTabController(
//                length: 2,
//                child: Builder(
//                  builder: (BuildContext context) => Padding(
//                    padding: const EdgeInsets.all(8.0),
//                    child: Column(
//                      children: <Widget>[
//                        Flexible(
//                          child:
//                            TabBarView(
//                              children: [
//                                Padding(
//                                  padding: EdgeInsets.all(10),
//                                  child:
//                                    Container(
//                                      color: Colors.blue,
//                                      child:
//                                        Column(
//                                          mainAxisAlignment: MainAxisAlignment.center,
//                                          crossAxisAlignment: CrossAxisAlignment.center,
//                                          children: <Widget>[
//                                            _buildMultilineTextField(1, "Product name",Icons.title),
//                                            _buildMultilineTextField(2, "Product description",Icons.description),
//                                            _buildValuePicker(),
//                                            _buildDateButton()
//                                          ],
//                                        ),
//                                    )
//
//                                ),
//                                Center(
//                                  child:_buildPictureGrild(),
//                                ),
//                              ],
//                            ),
//                        ),
//                        TabPageSelector(),
//                      ],
//                    )
//                  ),
//                ),
//              )
//          ),
//      bottomNavigationBar: _buildBottomBar(),
//    );
//  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              TabBarView(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Center(
                         child: Container(
                            padding: const EdgeInsets.all(10.0),
                            child: Material(

                              borderRadius: BorderRadius.all(const Radius.circular(25.0)),
                              elevation: 10.0,
                              child:Column(
                                children: <Widget>[
                                  _buildMultilineTextField(1, "Nom du produit", Icons.title),
                                  _buildMultilineTextField(2, "Description du produit", Icons.description),
                                  _buildValuePicker(),
                                  _buildDateButton()
                                ],
                              ),
                            ),
                          )
                      ),
                    ],
                  ),
                  _buildPictureGrild()
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: TabPageSelector(),
              )

            ],
          ),
          bottomNavigationBar: _buildBottomBar(),
        ),
      )
    );
  }
}