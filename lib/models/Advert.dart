import 'dart:ffi';

class Advert {

  String _title;
  String _price;
  String _description;
  String _image;


  Advert(this._title, this._price, this._description, this._image);

  String getTitle(){
    return this._title;
  }

  String getPrice(){
    return this._price;
  }

  String getDescription(){
    return this._description;
  }

  String getImage(){
    return this._image;
  }
}