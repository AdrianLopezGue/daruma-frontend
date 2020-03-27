import 'package:daruma/services/networking/custom-exception.dart';
import 'package:daruma/util/url.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'dart:async';

class ApiProvider {
  final String _baseUrl = Url.exchangeBaseUrl;

  Future<dynamic> get(String url) async {
    var responseJson;

    try {
      final response = await http.get(_baseUrl + url);
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> post(String url, String body) async {

    var responseJson;

    try {
      final response = await http.post(_baseUrl + url,
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
          body: body
      );
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }
  

  dynamic _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body);

        return responseJson;
      case 400:
        throw BadRequestException(response.body);
      case 401:

      case 403:
        throw UnauthorisedException(response.body);
      case 500:

      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
