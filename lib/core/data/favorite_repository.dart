abstract class FavoriteRepository {
  Future<List<String>> addFavorite(String advertId);
  Future<List<String>> deleteFavorite(String advertId);
}