import 'dart:convert';

import 'package:daruma/model/group.dart';
import 'package:daruma/services/networking/index.dart';
import 'package:daruma/util/url.dart';

class GroupRepository {
  ApiProvider _provider = ApiProvider();

  Future<bool> createGroup(Group group, String idToken) async {
    final String url = Url.apiBaseUrl + "/groups";

    var requestBody = jsonEncode(group);
    final response = await _provider.post(url, requestBody, idToken);

    return response;
  }

  Future<List<Group>> getGroups(String idToken) async {
    final response =
        await _provider.get(Url.apiBaseUrl + "/groups", header: idToken);

    var list = response as List;
    list = response.map<Group>((json) => Group.fromJson(json)).toList();

    return list;
  }

  Future<Group> getGroup(String idGroup, String idToken) async {
    final response =
        await _provider.get(Url.apiBaseUrl + "/groups/"+ idGroup, header: idToken);
    var group = Group.fromJson(response);

    return group;
  }

  Future<bool> deleteGroup(String idGroup, String idToken) async {

    final response =
        await _provider.delete(Url.apiBaseUrl + "/groups/"+ idGroup, idToken);

    return response;
  }

  Future<bool> updateGroupName(String idGroup, String name, String idToken) async {
    final String url = Url.apiBaseUrl + "/groups/" + idGroup;

    final Map body = {
      'name': name
    };

    var requestBody = jsonEncode(body);

    final response = await _provider.put(url, requestBody, idToken);

    return response;
  }
}
