

class TropsCategory {
  const TropsCategory(this.title, [this.subcategories = const <TropsCategory>[]]);
  final String title;
  final List<TropsCategory> subcategories;
}