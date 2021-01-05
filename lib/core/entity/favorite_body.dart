class FavoriteBody {
const FavoriteBody({this.favorite});

final String favorite;

Map<String,dynamic> toJson() => {
  'favorite': favorite
};
}