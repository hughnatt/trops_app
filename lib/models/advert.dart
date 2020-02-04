class Advert {

  var _title;
  var _price;
  var _description;
  var _image;

  Advert(this._title, this._price, this._description, this._image);

  getTitle(){
    return this._title;
  }

  getPrice(){
    return this._price;
  }

  getDescription(){
    return this._description;
  }

  getImage(){
    return this._image;
  }

}