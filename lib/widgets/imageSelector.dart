import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trops_app/utils/imagesManager.dart';
import 'package:trops_app/api/image.dart';
import 'package:http/http.dart' as Http;




class ImageSelector extends StatefulWidget {

  ImageSelector({Key key}) : super(key: key);

  @override
  ImageSelectorState createState() => ImageSelectorState();
  
}


enum SourceType {gallery, camera} //enum for the different sources of the images picked by the user

class ImageSelectorState extends State<ImageSelector> with AutomaticKeepAliveClientMixin<ImageSelector> {


  ImagesManager _imagesManager = ImagesManager(); //Object that allow us to load 4 images for the current advert that will be created
  bool _imageUploadProcessing; //boolean to know if the an image is currently uploading into server (for UI purpose)
  int _imageUploadProcessingIndex; //int to know at which index the image is currently uploaded

  @override
  void initState(){
    super.initState();
    _imageUploadProcessing = false; //when the user launche this page, non uploading is done
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

    return picture; //we return the FILE object choose by the user
  }


  void _imageUploadProcess(SourceType source, int index) async {
    var picture = await _openSource(context, index, source); //return the file choosen by the user

    var compressedPicture = await _imagesManager.compressAndGetFile(picture); //we get the compressed FILE object from the one choosed previously

    /*this.setState((){
      _imagesManager.loadFile(index, compressedPicture); //add the file to the imageMangaer
    });*/

    this.setState((){
      _imageUploadProcessing = true; //the user has choosed an image, so the upload is beginnin

      if(_imagesManager.get(index) != null){ //we the user want to change the image at an index where there is already one
        _imageUploadProcessingIndex = index; //the index is where we want to change
      }else{
        _imageUploadProcessingIndex = _imagesManager.getAll().length; //the image will be put at the end of the list
      }

    });

    Http.StreamedResponse uploadResponse = await uploadImage(compressedPicture); //upload the image on server

    if(uploadResponse.statusCode == 200){ //if the upload is a success
      Http.Response response = await Http.Response.fromStream(uploadResponse);
      addLink(index, response.body);
    }

    print("IMAGE SELECTOR UPLOAD" + _imagesManager.getAll().toString());

    this.setState((){
      _imageUploadProcessing = false; //in all case (success or failure, the upload process is done
      _imageUploadProcessingIndex = null; //the upload process is done, no index is concerned by the upload atm
    });

  }

  void addLink(int index, String link){
    this.setState((){
      _imagesManager.loadFile(index, link); //add the file to the imageMangaer
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
      _imagesManager.removeAt(index); //we remove the link at the given index
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

  getAllPaths(){
    return _imagesManager.getAll(); //we get the list of link
  }

  Widget _boxContent(int index) {
    if (_imagesManager.get(index) == null && _imageUploadProcessingIndex != index) { //if the given index have no image or is not concerned by the current upload
      return Icon(
        Icons.photo_camera,
        size: 50,
      );
    }
    else if(_imagesManager.get(index) != null) { //if there is an image
      //return Image.file(_imagesManager.get(index), fit: BoxFit.cover);
      return CachedNetworkImage(imageUrl: _imagesManager.get(index),fit: BoxFit.cover);
    }
    else if(_imageUploadProcessing && _imageUploadProcessingIndex == index){ //if there is an upload at the given index
      return Container(
          height: 50,
          width: 50,
          child: Center(
            child: CircularProgressIndicator(),
          )
      );
    }
    else {
      return null;
    }
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
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

  @override
  bool get wantKeepAlive => true;
}