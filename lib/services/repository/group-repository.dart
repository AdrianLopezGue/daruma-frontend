import 'dart:convert';

import 'package:daruma/model/group.dart';
import 'package:daruma/services/networking/index.dart';
import 'package:daruma/util/url.dart';
class GroupRepository {
  ApiProvider _provider = ApiProvider();

  Future<bool> createGroup(Group group, String idToken) async {
    final String url = Url.apiBaseUrl + "/groups";
    var requestBody = 
      {
        'groupId': group.idGroup,
        'name': group.name,
        'currencyCode': group.currencyCode,
        'idOwner': group.idOwner,
        'members': group.members.toString()
      };

    final response =
        await _provider.post(url, jsonEncode(requestBody), idToken);

    return response;
  }

  Future<List<Group>> getGroups(String idToken) async {
    final response = await _provider.get(Url.apiBaseUrl + "/groups", header: idToken);

    var list = response as List;
    list = response.map<Group>((json) => Group.fromJson(json)).toList();

    return list;
  }
}
