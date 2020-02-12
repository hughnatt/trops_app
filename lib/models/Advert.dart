class Advert {

  String _title;
  int _price;
  String _description;
  List<String> _photos;
  String _owner;
  String _category;


  Advert(this._title, this._price, this._description, this._photos, this._owner, this._category);

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
      return null;
    }
  }

  List<String> getAllImages(){
    if(!this.isEmpty()){
      return _photos;
    }
    else{
      return null;
    }
  }

  bool isEmpty(){
    return _photos.length == 0;
  }

  String getCategory(){
    return this._category;
  }

  String getOwner(){
    return this._owner;
  }
}