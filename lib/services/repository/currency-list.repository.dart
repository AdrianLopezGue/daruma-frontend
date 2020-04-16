import 'dart:async';
import 'package:daruma/model/currency-list.dart';
import 'package:daruma/services/networking/index.dart';
import 'package:daruma/util/url.dart';

class CurrencyListRepository {
  ApiProvider _provider = ApiProvider();

  Future<CurrencyList> fetchCurrencyList() async {
    final response = await _provider.get(Url.currencyListBaseUrl);

    return CurrencyList.fromJson(response);
  }
}
