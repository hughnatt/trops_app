import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/rendering/box.dart';
import 'package:image_picker/image_picker.dart';

class CreateAdvertPage extends StatefulWidget {

  @override
  _CreateAdvertPage createState() => _CreateAdvertPage();
}

class _CreateAdvertPage extends State<CreateAdvertPage> {

  List<File> imageFile = [null,null,null,null];

  _openGallery(BuildContext context, int index) async{
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    this.setState((){
      this.imageFile[index] = picture;
    });
  }

  _openCamera(BuildContext context,int index) async{
    var picture = await ImagePicker.pickImage(source: ImageSource.camera);
    this.setState((){
      this.imageFile[index] = picture;
    });
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
                  _openGallery(context,index);
                },
              ),

              Padding(padding: EdgeInsets.all(8.0)),
              GestureDetector(
                child: Text("Take picture"),
                onTap: (){
                  _openCamera(context,index);
                },
              )
            ],
          ),
        ),
      );
    });
  }

  Widget _buildMultilineTextField(int nbLines, String label) {
    return TextField(
      maxLines: nbLines,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        counterText: ' ',
        labelText: label,
        hintText: 'Type something...',
        border: OutlineInputBorder(),
      ),
      onChanged: (text) => setState(() {}),
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
    if(imageFile[index] == null){
      return Text(
        'Picture ' + (index+1).toString(),
        style: Theme.of(context).textTheme.headline,
      );
    }
    else{
      return Image.file(imageFile[index],fit: BoxFit.cover);
    }

}

  @override
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



  }
}