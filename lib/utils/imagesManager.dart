import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:trops_app/api/image.dart';
import 'package:trops_app/api/constants.dart';

class ImagesManager {
  final _imagesLink = List<String>(); // we declare a dynamic list (at beginning, none index is checkable !!)
  static const int MAX_IMAGES_FILES = 4;


  void loadFile(int index, String imageFile){
    if(this.get(index) == null){ //check if the current index does'nt already have a picture
     this.add(imageFile); //if yes, we add the picture to the end of the list
    }
    else{
      this.changeImage(index, imageFile); //else, we change the pictire for this given index
    }
  }

  void add(String imageFile) {
    if(_imagesLink.length < MAX_IMAGES_FILES) {
      _imagesLink.add(imageFile);
    }
  }

  void changeImage(int index, String imageFile){
    _imagesLink[index]= imageFile;
  }

  void removeAt(int index) {
    _imagesLink.removeAt(index);
  }

  String get(int index) {
    if(index < _imagesLink.length){ //this condition is to prevent to check index for a list lower of that index
      return _imagesLink[index];
    }
    else{ //the user try to access a index that is not defined is the list
      return null;
    }
  }

  List getAll() {
    return _imagesLink;
  }

  Future<File> compressAndGetFile(File file) async { //allow us to compress a given file and return the result

    var targetPath = await getTemporaryDirectory(); //we get the path to the cache of the application

    String fileName = file.path.split("/").last;

    var compressedImagePath = targetPath.path+"/"+fileName+DateTime.now().millisecondsSinceEpoch.toString()+".jpeg"; //we named the compressed file the function will return

    var result = await FlutterImageCompress.compressAndGetFile( //we compressed the file given at the compressedImagePath path with 20% of base quality into jpeg
      file.absolute.path,
        compressedImagePath,
      quality: 20,
      format: CompressFormat.jpeg
    );

    print(result.path);

    return result; //we return the compressed file
  }


  /*List<String> getAllFilePath(){ //return the path of the files for beign able to get them with API

    List<String> paths = List<String>();

    this._imagesLink.forEach((file) { //for each picture loaded by the user
      var endPath = file.path.split('/'); // we take only the name of the file
      String fullPath = "https://" + apiBaseURI + "/image/" + endPath.last; //we make the link compatible with the API
      paths.add(fullPath);
    });

    return paths; //return the List of all paths
  }*/
  
  /*void compressAndUploadImage(File pictureToUpload) async {
    var compressedPicture = await this.compressAndGetFile(pictureToUpload);
    uploadImage(compressedPicture);

  }*/
}