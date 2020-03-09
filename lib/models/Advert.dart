import 'package:trops_app/models/DateRange.dart';
import 'package:trops_app/models/Location.dart';

class Advert {

  String _id;
  String _title;
  double _price;
  String _description;
  List<String> _photos;
  String _owner;
  String _category;
  List<DateRange> _availability;
  Location _location;

  Advert(this._id, this._title, this._price, this._description, this._photos, this._owner, this._category, this._availability, this._location);

  String getId(){
    return this._id;
  }

  String getTitle(){
    return this._title;
  }

  String getPrice(){
    if(this._price%1 == 0){
      return this._price.toInt().toString();
    }
    else{
      return this._price.toString();
    }
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

  List<DateRange> getAvailability(){
    return this._availability;
  }

  Location getLocation(){
    return this._location;
  }
}