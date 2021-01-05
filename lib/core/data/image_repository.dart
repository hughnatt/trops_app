import 'dart:io';

import 'package:http/http.dart' as Http;

abstract class ImageRepository {
  Future<Http.StreamedResponse> uploadImage(File imageToUpload);
  Future<Http.Response> deleteImage(String imageToDelete);
  Future<Http.Response> deleteImageFromUrl(String url);
}