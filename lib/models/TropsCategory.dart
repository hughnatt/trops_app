

class TropsCategory {
  const TropsCategory(this.id, this.title, [this.subcategories = const <TropsCategory>[]]);
  final String id;
  final String title;
  final List<TropsCategory> subcategories;
}