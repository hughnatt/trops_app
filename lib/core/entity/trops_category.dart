

class TropsCategory {
  const TropsCategory(this.id, this.title, this.description, this.thumbnail, [this.subcategories = const <TropsCategory>[]]);
  final String id;
  final String title;
  final String description;
  final String thumbnail;
  final List<TropsCategory> subcategories;
}


TropsCategory findCategory(List<TropsCategory> categories, String id){
  if (categories != null){
    for (TropsCategory cat in categories){
      if (cat.id == id){
        return cat;
      }
      TropsCategory subcat = findCategory(cat.subcategories, id);
      if (subcat != null){
        return subcat;
      }
    }
  }
  return null;
}