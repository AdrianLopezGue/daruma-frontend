import 'dart:convert';

import 'package:daruma/model/user.dart';
import 'package:daruma/services/networking/index.dart';
import 'package:daruma/util/url.dart';

class UserRepository {
  ApiProvider _provider = ApiProvider();

  Future<bool> createUser(User user, String idToken) async {
    final String url = Url.apiBaseUrl + "/users";

    var requestBody = jsonEncode(user);
    final response =
        await _provider.post(url, requestBody, idToken);

    return response;
  }
}