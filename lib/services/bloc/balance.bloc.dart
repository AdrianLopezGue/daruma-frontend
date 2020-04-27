import 'dart:async';
import 'dart:collection';
import 'package:daruma/model/transaction.dart';
import 'package:daruma/services/balance-calculator/balance-calculator.dart';
import 'package:daruma/services/networking/index.dart';
import 'package:daruma/services/repository/balance.repository.dart';
import 'package:rxdart/subjects.dart';

class BalanceBloc {
  BalanceRepository _balanceRepository;
  StreamController _balanceController;

  StreamSink<Response<List<Transaction>>> get balanceSink =>
      _balanceController.sink;
      

  Stream<Response<List<Transaction>>> get balanceStream =>
      _balanceController.stream;

  BalanceBloc() {
    _balanceController = BehaviorSubject<Response<List<Transaction>>>();
    _balanceRepository = BalanceRepository();
    
  }

  getBalance(String idToken, String idGroup) async {
    balanceSink.add(Response.loading('Getting Balance of Group.'));
    try {
      HashMap<String, int> balance =
          await _balanceRepository.getBalance(idToken, idGroup);
      
      BalanceCalculator balanceCalculator = new BalanceCalculator(transactions: balance);

      balanceSink.add(Response.completed(balanceCalculator.getTransactions()));
    } catch (e) {
      balanceSink.add(Response.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _balanceController?.close();
  }
}