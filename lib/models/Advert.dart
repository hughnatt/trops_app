class Advert {

  String _title;
  int _price;
  String _description;
  List<String> _photos;


  Advert(this._title, this._price, this._description, this._photos);

  String getTitle(){
    return this._title;
  }

  int getPrice(){
    return this._price;
  }

  String getDescription(){
    return this._description;
  }

  String getFirstImage(){
    if(!this.isEmpty()){
      return _photos.elementAt(0);
    }
    else{
      return "https://external-content.duckduckgo.com/iu/?u=http%3A%2F%2Fmaestroselectronics.com%2Fwp-content%2Fuploads%2F2017%2F12%2FNo_Image_Available.jpg";
    }
  }

  bool isEmpty(){
    return _photos.length == 0;
  }
}