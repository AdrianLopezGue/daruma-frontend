class CurrencyList {
  final List<Currency> rates;

  CurrencyList([this.rates]);

  factory CurrencyList.fromJson(Map<String, dynamic> json) {
    return CurrencyList(_parseRates(json));
  }
}

class Currency {
  String code;
  String name;

  Currency(this.code, this.name);
}

List<Currency> _parseRates(Map<String, dynamic> json) {
  return json.keys.map((code) => Currency(code, json[code])).toList();
}
