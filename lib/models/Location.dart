class Location {

  String _label;
  String _city;
  String _postcode;

  Location(this._label, this._city, this._postcode);

  String getLabel(){
    return this._label;
  }

  String getCity(){
    return this._city;
  }

  String getPostcode(){
    return this._postcode;
  }

  String getRelativePosition(){
    return this._city + " " + this._postcode;
  }

  String setLabel(String label){
    this._label = label;
  }

  String setCity(String city){
    this._city = city;
  }

  String setPostcode(String postcode){
    this._postcode = postcode;
  }
}