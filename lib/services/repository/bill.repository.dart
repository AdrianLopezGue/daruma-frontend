import 'dart:convert';

import 'package:daruma/model/bill.dart';
import 'package:daruma/services/networking/index.dart';
import 'package:daruma/util/url.dart';

class BillRepository {
  ApiProvider _provider = ApiProvider();

  Future<bool> createBill(Bill bill, String tokenId) async {
    final String url = Url.apiBaseUrl + "/bills";

    var requestBody = jsonEncode(bill);
    final response = await _provider.post(url, requestBody, tokenId);

    return response;
  }

  Future<bool> updateBill(Bill bill, String tokenId) async {
    final String url = Url.apiBaseUrl + "/bills/" + bill.billId;

    var requestBody = jsonEncode(bill);
    final response = await _provider.put(url, requestBody, tokenId);

    return response;
  }

  Future<List<Bill>> getBills(String groupId, String tokenId) async {
    final response = await _provider.get(Url.apiBaseUrl + "/bills/" + groupId,
        header: tokenId);

    var list = response as List;
    list = response.map<Bill>((json) => Bill.fromJson(json)).toList();

    return list;
  }

  Future<bool> deleteBill(String billId, String tokenId) async {
    final response =
        await _provider.delete(Url.apiBaseUrl + "/bills/" + billId, tokenId);

    return response;
  }
}
