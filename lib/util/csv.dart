import 'package:csv/csv.dart';
import 'package:daruma/model/bill.dart';

class CsvHelper {
  static CsvHelper _instance;
  ListToCsvConverter _listToCsvConverter = ListToCsvConverter();

  factory CsvHelper() {
    if (_instance == null) _instance = CsvHelper._internal();
    return _instance;
  }

  CsvHelper._internal();

  String billsToCsv(List<Bill> bills) {
    List<List<dynamic>> convertMaterial = [
      [
        'Nombre',
        'Fecha',
        'Coste',
        'Moneda',
      ]
    ];
    bills.map((Bill variant) {
      List<dynamic> toAdd = [];
      toAdd.add(variant.name);
      toAdd.add(variant.date);
      toAdd.add(variant.money);
      toAdd.add(variant.currencyCode);
      convertMaterial.add(toAdd);
    }).toList();
    return _listToCsvConverter.convert(convertMaterial);
  }
}