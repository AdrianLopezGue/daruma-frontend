import 'package:daruma/services/networking/custom-exception.dart';
import 'package:daruma/util/url.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'dart:async';

class ApiProvider {

  Future<dynamic> get(String url, {String header}) async {
    var responseJson;

    try {
      final response = await http.get(url, headers: {HttpHeaders.authorizationHeader: '$header'});
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> post(String url, String body, String header) async {
    var responseJson;

    try {
      final response = await http.post(url,
          headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: '$header'},
          body: body);

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

      case 204:       

        return true;
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
