import 'dart:convert' show jsonEncode, jsonDecode;
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as Http;
import 'package:trops_app/core/constants.dart';
import 'package:trops_app/core/data/advert_repository.dart';
import 'package:trops_app/core/data/category_repository.dart';
import 'package:trops_app/core/entity/advert.dart';
import 'package:trops_app/core/entity/advert_upload_status.dart';
import 'package:trops_app/core/entity/create_advert.dart';
import 'package:trops_app/core/entity/date_range.dart';
import 'package:trops_app/core/entity/location.dart';
import 'package:trops_app/core/entity/user.dart';
import 'package:trops_app/data/http_session.dart';
import 'package:trops_app/data/mapper/advert_mapper.dart';

class AdvertRepositoryImpl implements AdvertRepository {

  HttpSession _httpSession;
  CategoryRepository _categoryRepository;

  AdvertRepositoryImpl({
    @required HttpSession httpSession,
    @required CategoryRepository categoryRepository
  }) {
    _httpSession = httpSession;
    _categoryRepository = categoryRepository;
  }

  @override
  Future<List<Advert>> getAllAdverts()  async {
    return getAdvertsByUser(null);
  }

  @override
  Future<List<Advert>> getAdvertsByUser(User user) async {
    if (user == null){
      return _httpSession.get(
        url: Uri.https(Constants.apiBaseURI, '/advert'),
        mapper: (response) => AdvertListMapper(categoryRepository: _categoryRepository).map(jsonDecode(response))
      );
    } else {
      return _httpSession.get(
        url:  Uri.https(Constants.apiBaseURI, '/advert/owner/' + user.id),
        mapper: (response) => AdvertListMapper(categoryRepository: _categoryRepository).map(jsonDecode(response))
      );
    }
  }

  @override
  Future<Advert> getAdvertsById(String id) async {
    return _httpSession.get(
      url: Uri.https(Constants.apiBaseURI, '/advert/' + id),
      mapper: (response) => AdvertMapper(categoryRepository: _categoryRepository).map(jsonDecode(response))
    );
  }

  @override
  Future<AdvertUploadStatus> uploadAdvert({
    String title,
    double price,
    String description,
    String category,
    String owner,
    List<String> photos,
    List<DateRange> availability,
    Location location
  }) async {
    CreateAdvert createAdvertBody = CreateAdvert(
      title: title,
      price: price,
      description: description,
      category: category,
      owner: owner,
      photos: photos,
      availability: availability,
      location: location
    );
    return _httpSession.post(
      url: Uri.https(Constants.apiBaseURI, "/advert"),
      body: jsonEncode(createAdvertBody),
      statusHandler: ({Http.Response response}) {
        switch(response.statusCode) {
          case 201:
            return AdvertUploadStatus.SUCCESS;
          default:
            return AdvertUploadStatus.FAILURE;
        }
      }
    );
  }

  @override
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
  }) async {
    CreateAdvert createAdvertBody = CreateAdvert(
      title: title,
      price: price,
      description: description,
      category: category,
      owner: owner,
      photos: photos,
      availability: availability,
      location: location
    );
    return _httpSession.put(
      url: Uri.https(Constants.apiBaseURI, "/advert/"+id),
      body: jsonEncode(createAdvertBody),
      statusHandler: ({Http.Response response}) {
        switch(response.statusCode) {
          case 200:
            return AdvertUploadStatus.SUCCESS;
          default:
            return AdvertUploadStatus.FAILURE;
        }
      }
    );
  }

  @override
  Future<Http.Response> deleteAdvert(String id)  {
    return _httpSession.delete(
      url: Uri.https(Constants.apiBaseURI,  "/advert/" + id),
      mapper: ((response) => response)
    );
  }
}