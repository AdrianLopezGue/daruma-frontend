import 'dart:convert';

import 'package:daruma/model/user.dart';
import 'package:daruma/services/networking/index.dart';
import 'package:daruma/util/url.dart';

class UserRepository {
  ApiProvider _provider = ApiProvider();

  Future<bool> createUser(User user, String tokenId) async {
    final String url = Url.apiBaseUrl + "/users";

    var requestBody = jsonEncode(user);
    final response = await _provider.post(url, requestBody, tokenId);

    return response;
  }

  Future<User> getUser(String userId, String tokenId) async {
    final response = await _provider.get(Url.apiBaseUrl + "/users/" + userId,
        header: tokenId);

    var user;

    if (response != null) {
      user = User.fromJson(response);
    }

    return user;
  }

  Future<bool> updateUser(
      String userId, String name, String paypal, String tokenId) async {
    final String url = Url.apiBaseUrl + "/users/" + userId;

    final Map body = {
      'name': name,
      'paypal': paypal,
    };

    var requestBody = jsonEncode(body);

    final response = await _provider.put(url, requestBody, tokenId);

    return response;
  }
}
