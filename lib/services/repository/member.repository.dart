import 'dart:convert';

import 'package:daruma/model/member.dart';
import 'package:daruma/services/networking/index.dart';
import 'package:daruma/util/url.dart';

class MemberRepository {
  ApiProvider _provider = ApiProvider();

  Future<List<Member>> getMembers(String idGroup, String idToken) async {
    final response = await _provider.get(Url.apiBaseUrl + "/members/" + idGroup,
        header: idToken);

    var list = response as List;
    list = response.map<Member>((json) => Member.fromJson(json)).toList();

    return list;
  }

  Future<bool> addMember(Member member, String idGroup, String idToken) async {
    final String url = Url.apiBaseUrl + "/members";

    final Map body = {
      'id': member.idMember,
      'groupId': idGroup,
      'name': member.name,
    };

    var requestBody = jsonEncode(body);
    final response = await _provider.post(url, requestBody, idToken);

    return response;
  }

  Future<bool> deleteMember(String idMember, String idToken) async {
    final response = await _provider.delete(
        Url.apiBaseUrl + "/members/" + idMember, idToken);

    return response;
  }

  Future<bool> setUserIdToMember(
      String idMember, String idUser, String idToken) async {
    final String url = Url.apiBaseUrl + "/members/" + idMember;

    final Map body = {'idUser': idUser};

    var requestBody = jsonEncode(body);

    final response = await _provider.patch(url, requestBody, idToken);

    return response;
  }
}
