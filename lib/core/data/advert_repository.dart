import 'package:http/http.dart' as Http;
import 'package:trops_app/core/entity/advert.dart';
import 'package:trops_app/core/entity/advert_upload_status.dart';
import 'package:trops_app/core/entity/user.dart';
import 'package:trops_app/core/entity/date_range.dart';
import 'package:trops_app/core/entity/location.dart';

abstract class AdvertRepository {
  Future<List<Advert>> getAllAdverts();
  Future<List<Advert>> getAdvertsByUser(User user);
  Future<Advert> getAdvertsById(String id);
  Future<AdvertUploadStatus> uploadAdvert({
    String title,
    double price,
    String description,
    String category,
    String owner,
    List<String> photos,
    List<DateRange> availability,
    Location location
  });
  Future<AdvertUploadStatus> modifyAdvert({
    String id,
    String title,
    double price,
    String description,
    String category,
    String owner,
    List<String> photos,
    List<DateRange> availability,
    Location location
  });
  Future<Http.Response> deleteAdvert(String id);
}