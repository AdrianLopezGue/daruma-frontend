import 'dart:convert';

import 'package:daruma/model/group.dart';
import 'package:daruma/services/networking/index.dart';
class GroupRepository {
  ApiProvider _provider = ApiProvider();

  Future<bool> createGroup(Group group, String idToken) async {
    final String parameterUrl = "/groups";
    var requestBody = 
      {
        'name': group.name,
        'currencyCode': group.currencyCode,
        'idOwner': group.idOwner
      }
    ;

    final response =
        await _provider.post(parameterUrl, jsonEncode(requestBody), idToken);

    return response;
  }

  Future<List<Group>> getGroups(String idToken) async {
    final response = await _provider.get("/groups", idToken);

    var list = response as List;
    list = response.map<Group>((json) => Group.fromJson(json)).toList();

    return list;
  }
}
