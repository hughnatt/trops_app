class FavoriteMapper {

  List<String> map(dynamic json) {
    List<String> _userFavorite = new List<String>();
    for (var item in json) {
      _userFavorite.add(item); //add each advertId in the favoriteList to return
    }
    return _userFavorite;
  }
}