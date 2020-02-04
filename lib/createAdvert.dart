import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/rendering/box.dart';
import 'package:image_picker/image_picker.dart';

class CreateAdvertPage extends StatefulWidget {

  @override
  _CreateAdvertPage createState() => _CreateAdvertPage();
}

class _CreateAdvertPage extends State<CreateAdvertPage> {

  List<File> imageFiles = List(4);
  int imageIndex = 0;

  _openGallery(BuildContext context, int index) async{
    int indexToSave;
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    this.setState((){
      if(imageIndex == 4){
        indexToSave = index;
      }
      else{
        indexToSave= imageIndex;
        imageIndex++;
      }
      this.imageFiles[indexToSave] = picture;
    });
    Navigator.of(context).pop();
  }

  _openCamera(BuildContext context,int index) async{
    int indexToSave;
    var picture = await ImagePicker.pickImage(source: ImageSource.camera);
    this.setState((){
      if(imageIndex == 4){
        indexToSave = index;
      }
      else{
        indexToSave= imageIndex;
        imageIndex++;
      }
      this.imageFiles[indexToSave] = picture;
    });
    Navigator.of(context).pop();
  }

  _openSource(BuildContext context,@required int index, @required String source) async{

    int indexToSave;
    ImageSource sourceChoice;

    switch(source) {
      case "camera": {
        sourceChoice = ImageSource.camera;
      }
      break;

      case "gallery": {
        sourceChoice = ImageSource.gallery;
      }
      break;
    }

    var picture = await ImagePicker.pickImage(source: sourceChoice);
    this.setState((){
      if(imageIndex == 4){
        indexToSave = index;
      }
      else{
        indexToSave= imageIndex;
        imageIndex++;
      }
      this.imageFiles[indexToSave] = picture;
    });
    Navigator.of(context).pop();
  }

  Future<void> _showChoiceDialog(BuildContext context, int index){
    return showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text("How to import picture ?"),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              GestureDetector(
                child: Text("Load picture"),
                onTap: (){
                  _openSource(context,index,"gallery");
                },
              ),

              Padding(padding: EdgeInsets.all(8.0)),
              GestureDetector(
                child: Text("Take picture"),
                onTap: (){
                  _openSource(context,index,"camera");
                },
              )
            ],
          ),
        ),
      );
    });
  }

  Widget _buildMultilineTextField(int nbLines, String label, IconData iconName) {
    return Container(
        padding: EdgeInsets.only(top: 50),
        child : 
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

  Widget _buildValuePicker(){
    return Container(
      padding: EdgeInsets.only(top: 50),
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


  Widget _buildPictureGrild(){
    return GridView.count(
      crossAxisCount: 2,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: List.generate(4, (index) {
        return Center(
          child: GestureDetector(
            onTap: (){
              _showChoiceDialog(context,index);
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

Widget _boxContent(int index){
    if(imageFiles[index] == null){
      return Icon(
          Icons.camera_enhance,
          size: 50,
      );
    }
    else{
      return Image.file(imageFiles[index],fit: BoxFit.cover);
    }
}

Widget _createBottomBar(){
  return BottomAppBar(
    shape: const CircularNotchedRectangle(),
    child: Container(
      height: 50.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(width: 1),
          IconButton(icon: Icon(Icons.home), onPressed : () {}),
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

  /*@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Advert')
    ),
      body: SafeArea (
        child :
        Card(
            elevation: 20.0,
            margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
            child: ListView(
              padding: EdgeInsets.all(8.0),
              children: <Widget>[
                _buildMultilineTextField(1,'Product name'),
                _buildMultilineTextField(3,'Product description'),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0),
                    borderRadius: new BorderRadius.only(
                                  topLeft:  const  Radius.circular(5),
                                  topRight: const  Radius.circular(5),
                                  bottomLeft: const  Radius.circular(5),
                                  bottomRight: const  Radius.circular(5),
                    )
                  ),
                  child: _buildPictureGrild(),
                ),
              ],
            )
            )
      ),
    );
  }*/


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body:
          SafeArea(
            child:
              DefaultTabController(
                length: 3,
                child: Builder(
                  builder: (BuildContext context) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        TabPageSelector(),
                        Expanded(
                          child:
                            TabBarView(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child:
                                      Center(
                                        child:
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              _buildMultilineTextField(1, "Product name",Icons.title),
                                              _buildMultilineTextField(2, "Product description",Icons.description),
                                              _buildValuePicker()
                                            ],
                                          ),
                                      )

                                ),
                                Center(
                                  child:_buildPictureGrild(),
                                ),
                                _buildPictureGrild()
                              ],
                            ),
                        ),
                      ],
                    )
                  ),
                ),
              )
          ),
      bottomNavigationBar: _createBottomBar(),
    );
  }
}