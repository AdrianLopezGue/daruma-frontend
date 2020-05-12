import 'package:flutter_config/flutter_config.dart';

class Url {
  static String apiBaseUrl = FlutterConfig.get('HOST');
  static String currencyListBaseUrl =
      'https://openexchangerates.org/api/currencies.json';
}
