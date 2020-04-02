import 'dart:async';
import 'package:daruma/model/currency-list.dart';
import 'package:daruma/services/networking/index.dart';
import 'package:daruma/services/repository/currency-list-repository.dart';
import 'package:rxdart/subjects.dart';

class CurrencyListBloc {
  CurrencyListRepository _currencyListRepository;
  StreamController _currencyListController;

  StreamSink<Response<CurrencyList>> get currencyListSink =>
      _currencyListController.sink;

  Stream<Response<CurrencyList>> get currencyListStream =>
      _currencyListController.stream;

  CurrencyListBloc() {
    _currencyListController = BehaviorSubject<Response<CurrencyList>>();
    _currencyListRepository = CurrencyListRepository();
  }

  fetchCurrencyList() async {
    currencyListSink.add(Response.loading('Getting Currency List.'));
    try {
      CurrencyList currencyList =
          await _currencyListRepository.fetchCurrencyList();

      currencyListSink.add(Response.completed(currencyList));
    } catch (e) {
      currencyListSink.add(Response.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _currencyListController?.close();
  }
}