import 'dart:io';
import 'package:http/http.dart' as Http;
import 'package:trops_app/api/api.dart';


Future<Http.StreamedResponse> uploadImage(File imageToUpload) async {
  var uri = new Uri.https(apiBaseURI, "/image");


  //create multipart request for POST or PATCH method
  var request = Http.MultipartRequest("POST", uri);

  //create multipart using filepath, string or bytes
  var image = await Http.MultipartFile.fromPath("image", imageToUpload.path);

  //add multipart to request
  request.files.add(image);
  var response = await request.send();

  print(response.statusCode);


  return response;

}