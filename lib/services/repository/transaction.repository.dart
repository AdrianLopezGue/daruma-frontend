import 'dart:convert';

import 'package:daruma/model/transaction.dart';
import 'package:daruma/services/networking/index.dart';
import 'package:daruma/util/url.dart';

class TransactionRepository {
  ApiProvider _provider = ApiProvider();

  Future<bool> createTransfer(Transaction transaction, String idToken) async {
    final String url = Url.apiBaseUrl + "/transactions";

    var requestBody = jsonEncode(transaction);

    final response = await _provider.post(url, requestBody, idToken);

    return response;
  }
}
