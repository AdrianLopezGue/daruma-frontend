import 'dart:convert';

import 'package:daruma/model/bill.dart';
import 'package:daruma/services/networking/index.dart';
import 'package:daruma/util/url.dart';

class BillRepository {
  ApiProvider _provider = ApiProvider();

  Future<bool> createBill(Bill bill, String idToken) async {
    final String url = Url.apiBaseUrl + "/bills";

    var requestBody = jsonEncode(bill);
    final response = await _provider.post(url, requestBody, idToken);

    return response;
  }

  Future<List<Bill>> getBills(String idToken, String idGroup) async {
    final response =
        await _provider.get(Url.apiBaseUrl + "/bills/" + idGroup, header: idToken);

    var list = response as List;
    list = response.map<Bill>((json) => Bill.fromJson(json)).toList();

    return list;
  }
}