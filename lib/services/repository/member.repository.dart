import 'dart:convert';

import 'package:daruma/model/member.dart';
import 'package:daruma/services/networking/index.dart';
import 'package:daruma/util/url.dart';

class MemberRepository {
  ApiProvider _provider = ApiProvider();

  Future<List<Member>> getMembers(String groupId, String tokenId) async {
    final response = await _provider.get(Url.apiBaseUrl + "/members/" + groupId,
        header: tokenId);

    var list = response as List;
    list = response.map<Member>((json) => Member.fromJson(json)).toList();

    return list;
  }

  Future<bool> addMember(Member member, String groupId, String tokenId) async {
    final String url = Url.apiBaseUrl + "/members";

    final Map body = {
      '_id': member.memberId,
      'groupId': groupId,
      'name': member.name,
    };

    var requestBody = jsonEncode(body);
    final response = await _provider.post(url, requestBody, tokenId);

    return response;
  }

  Future<bool> deleteMember(String memberId, String tokenId) async {
    final response = await _provider.delete(
        Url.apiBaseUrl + "/members/" + memberId, tokenId);

    return response;
  }

  Future<bool> setUserIdToMember(
      String memberId, String userId, String tokenId) async {
    final String url = Url.apiBaseUrl + "/members/" + memberId;

    final Map body = {'userId': userId};

    var requestBody = jsonEncode(body);

    final response = await _provider.patch(url, requestBody, tokenId);

    return response;
  }
}
