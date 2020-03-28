import 'dart:convert';

import 'package:daruma/model/group.dart';
import 'package:daruma/services/networking/index.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GroupRepository {
  ApiProvider _provider = ApiProvider();

  Future<Group> createGroup(Group group, String idToken) async {
    final String parameterUrl = "/groups/";
    var requestBody = [
      {
        'name': group.name,
        'currencyCode': group.currencyCode,
        'idOwner': group.idOwner
      }
    ];

    final response =
        await _provider.post(parameterUrl, jsonEncode(requestBody), idToken);

    return response;
  }
}
