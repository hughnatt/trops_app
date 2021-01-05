import 'package:trops_app/core/entity/trops_category.dart';

abstract class CategoryRepository {
  Future<List<TropsCategory>> getCategories();
  List<TropsCategory> getSubcategories(parentName,json);
  String getCategoryNameByID(String id);
  String getIDByCategoryName(String name);
}