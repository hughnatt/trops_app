class SearchBody {
  const SearchBody({this.text,this.priceMin,this.priceMax,this.categories, this.location, this.distance});

  final String text;
  final int priceMin;
  final int priceMax;
  final List<String> categories;
  final List<double> location;
  final int distance;

  Map<String,dynamic> toJson() => {
    'text': text,
    'priceMin': priceMin,
    'priceMax': priceMax,
    'categories': categories,
    'location': location,
    'distance': distance * 1000
  };
}