
import 'package:daruma/model/member.dart';
import 'package:daruma/services/networking/index.dart';
import 'package:daruma/util/url.dart';

class MemberRepository {
  ApiProvider _provider = ApiProvider();

  Future<List<Member>> getMembers(String idGroup, String idToken) async {
    final response =
        await _provider.get(Url.apiBaseUrl + "/members/" + idGroup, header: idToken);

    var list = response as List;
    list = response.map<Member>((json) => Member.fromJson(json)).toList();

    return list;
  }
}