import 'package:trops_app/core/entity/location.dart';

abstract class LocationRepository {
  Future<List<Location>> query(String query);
}