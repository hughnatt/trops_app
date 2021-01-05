import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as Http;
import 'package:trops_app/data/token_provider.dart';

class HttpSession {

  TokenProvider _tokenProvider;

  void setTokenProvider({@required TokenProvider tokenProvider}) {
    _tokenProvider = tokenProvider;
  }

  Future<T> put<T>({Uri url, body, T mapper(dynamic), T statusHandler({Http.Response response})}) async {
    Http.Response response = await Http.put(
      url,
      headers: {
        "Authorization": "Bearer ${_tokenProvider.getToken()}",
        "Content-type": "application/json"
      },
      body: body
    );
    if (statusHandler != null) {
      return statusHandler(response: response);
    } else {
      return _defaultStatusHandler(response: response, mapper: mapper);
    }
  }

  Future<T> post<T>({Uri url, body, T mapper(dynamic), T statusHandler({Http.Response response})}) async {
    Http.Response response = await Http.post(
      url,
      headers: {
        "Authorization": "Bearer ${_tokenProvider.getToken()}",
        "Content-type": "application/json"
      },
      body: body
    );
    if (statusHandler != null) {
      return statusHandler(response: response);
    } else {
      return _defaultStatusHandler(response: response, mapper: mapper);
    }
  }

  Future<T> get<T>({Uri url, T mapper(dynamic), T statusHandler({Http.Response response})}) async {
    Http.Response response = await Http.get(
      url,
      headers: {
        "Authorization": "Bearer ${_tokenProvider.getToken()}",
        "Content-type": "application/json"
      }
    );
    if (statusHandler != null) {
      return statusHandler(response: response);
    } else {
      return _defaultStatusHandler(response: response, mapper: mapper);
    }
  }

  Future<T> delete<T>({Uri url, T mapper(dynamic), T statusHandler({Http.Response response})}) async {
    Http.Response response = await Http.delete(
      url,
      headers: {
        "Authorization": "Bearer ${_tokenProvider.getToken()}",
        "Content-type": "application/json"
      }
    );
    if (statusHandler != null) {
      return statusHandler(response: response);
    } else {
      return _defaultStatusHandler(response: response, mapper: mapper);
    }
  }

  T _defaultStatusHandler<T>({Http.Response response, T mapper(dynamic)}) {
    switch (response.statusCode) {
      case 200:
      case 201:
        try {
          return mapper(jsonDecode(response.body));
        } catch (Exception) {
          rethrow;
        }
        break;
      default:
        throw Exception(response.reasonPhrase);
    }
  }
}