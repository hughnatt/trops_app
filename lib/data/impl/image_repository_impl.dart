import 'package:trops_app/core/constants.dart';
import 'package:trops_app/core/data/image_repository.dart';
import 'dart:io';
import 'package:http/http.dart' as Http;

class ImageRepositoryImpl implements ImageRepository {

  @override
  Future<Http.StreamedResponse> uploadImage(File imageToUpload) async {
    var uri = new Uri.https(Constants.apiBaseURI, "/image");
    //create multipart request for POST or PATCH method
    var request = Http.MultipartRequest("POST", uri);
    //create multipart using filepath, string or bytes
    var image = await Http.MultipartFile.fromPath("image", imageToUpload.path);
    //add multipart to request
    request.files.add(image);
    var response = await request.send();
    return response;

  }

  @override
  Future<Http.Response> deleteImage(String imageToDelete) async { //function that will delete an image from the server
    //var splitedPath = imageToDelete.path.split('/');
    var response = await Http.delete(imageToDelete); //we contact the API with a delet to trigger the deletion process in the back end
    return response;
  }

  @override
  Future<Http.Response> deleteImageFromUrl(String url) async {
    var uri = new Uri.https(Constants.apiBaseURI, "/image/"+ url);
    var response = await Http.delete(uri);
    return response;
  }
}