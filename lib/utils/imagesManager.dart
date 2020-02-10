import 'dart:io';



class ImagesManager {
  final _imagesFiles = List<File>(); // we declare a dynamic list (at beginning, none index is checkable !!)
  static final int MAX_IMAGES_FILES = 4;



  void loadFile(int index, File imageFile){
    if(this.get(index) == null){ //check if the current index does'nt already have a picture
     this.add(imageFile); //if yes, we add the picture to the end of the list
    }
    else{
      this.changeImage(index, imageFile); //else, we change the pictire for this given index
    }
  }

  void add(File imageFile) {
    if(_imagesFiles.length < MAX_IMAGES_FILES) {
      _imagesFiles.add(imageFile);
    }
  }

  void changeImage(int index, File imageFile){
    _imagesFiles[index]= imageFile;
  }

  void removeAt(int index) {
    _imagesFiles.removeAt(index);
  }

  File get(int index) {
    if(index < _imagesFiles.length){ //this condition is to prevent to check index for a list lower of that index
      return _imagesFiles[index];
    }
    else{ //the user try to access a index that is not defined is the list
      return null;
    }
  }

  List getAll() {
    return _imagesFiles;
  }
}