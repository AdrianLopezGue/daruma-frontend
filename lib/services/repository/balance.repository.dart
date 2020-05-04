import 'dart:collection';

import 'package:daruma/model/balance.dart';
import 'package:daruma/services/networking/index.dart';
import 'package:daruma/util/url.dart';

class BalanceRepository {
  ApiProvider _provider = ApiProvider();

  Future<HashMap<String, int>> getBalance(
      String tokenId, String groupId) async {
    final response = await _provider.get(Url.apiBaseUrl + "/balance/" + groupId,
        header: tokenId);

    var list = response as List;
    list = response.map<Balance>((json) => Balance.fromJson(json)).toList();

    HashMap<String, int> result = HashMap.fromIterable(list,
        key: (e) => e.memberId, value: (e) => e.money);

    return result;
  }
}
