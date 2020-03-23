class Location {

  String _label;
  String _city;
  String _postcode;
  List<double> _coordinates = List<double>(2);

  Location(this._label, this._city, this._postcode, this._coordinates);

  Map<String,dynamic> toJson() => {
    'label' : _label,
    'city' : _city,
    'postcode' : _postcode,
    'coordinates' : _coordinates
  };

  String getLabel(){
    return this._label;
  }

  String getCity(){
    return this._city;
  }

  String getPostcode(){
    return this._postcode;
  }

  List<double> getCoordinates(){
    return this._coordinates;
  }

  setLabel(String label){
    this._label = label;
  }

  setCity(String city){
    this._city = city;
  }

  setPostcode(String postcode){
    this._postcode = postcode;
  }

  setCoordinates(List<double> coordinates){
    this._coordinates = coordinates;
  }

}