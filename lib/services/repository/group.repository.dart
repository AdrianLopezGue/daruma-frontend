import 'dart:convert';

import 'package:daruma/model/group.dart';
import 'package:daruma/services/networking/index.dart';
import 'package:daruma/util/url.dart';

class GroupRepository {
  ApiProvider _provider = ApiProvider();

  Future<bool> createGroup(Group group, String tokenId) async {
    final String url = Url.apiBaseUrl + "/groups";

    var requestBody = jsonEncode(group);
    final response = await _provider.post(url, requestBody, tokenId);

    return response;
  }

  Future<List<Group>> getGroups(String tokenId) async {
    final response =
        await _provider.get(Url.apiBaseUrl + "/groups", header: tokenId);

    var list = response as List;
    list = response.map<Group>((json) => Group.fromJson(json)).toList();

    return list;
  }

  Future<Group> getGroup(String groupId, String tokenId) async {
    final response = await _provider.get(Url.apiBaseUrl + "/groups/" + groupId,
        header: tokenId);
    var group = Group.fromJson(response);

    return group;
  }

  Future<bool> deleteGroup(String groupId, String tokenId) async {
    final response =
        await _provider.delete(Url.apiBaseUrl + "/groups/" + groupId, tokenId);

    return response;
  }

  Future<bool> updateGroup(
      String groupId, String name, String currencyCode, String tokenId) async {
    final String url = Url.apiBaseUrl + "/groups/" + groupId;

    final Map body = {
      'name': name,
      'currencyCode': currencyCode,      
    };

    var requestBody = jsonEncode(body);

    final response = await _provider.patch(url, requestBody, tokenId);

    return response;
  }
}
