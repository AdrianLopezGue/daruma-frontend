import 'dart:collection';
import 'package:daruma/model/group.dart';
import 'package:daruma/model/transaction.dart';

class BalanceCalculator {
  final HashMap<String, int> transactions;
  final Group group;
  List<Transaction> finalTransactions;

  BalanceCalculator({this.transactions, this.group}) {
    finalTransactions = [];
    _calculateBalance(transactions);
  }

  void _calculateBalance(HashMap<String, int> transactions) {
    var maxValue =
        transactions.values.reduce((curr, next) => curr > next ? curr : next);
    var minValue =
        transactions.values.reduce((curr, next) => curr < next ? curr : next);

    if (maxValue != minValue) {
      String maxKey = _getKeyFromValue(maxValue);
      String minKey = _getKeyFromValue(minValue);
      int result = maxValue + minValue;
      if ((result >= 0)) {
        finalTransactions.add(new Transaction(
            sender: minKey,
            beneficiary: maxKey,
            money: minValue.abs(),
            currencyCode: group.currencyCode,
            idGroup: group.idGroup));
        transactions.remove(maxKey);
        transactions.remove(minKey);
        transactions[maxKey] = result;
        transactions[minKey] = 0;
      } else {
        finalTransactions.add(new Transaction(
            sender: minKey,
            beneficiary: maxKey,
            money: maxValue.abs(),
            currencyCode: group.currencyCode,
            idGroup: group.idGroup));

        transactions.remove(maxKey);
        transactions.remove(minKey);
        transactions[maxKey] = 0;
        transactions[minKey] = result;
      }

      _calculateBalance(transactions);
    }
  }

  String _getKeyFromValue(int value) {
    return transactions.keys
        .firstWhere((k) => transactions[k] == value, orElse: () => null);
  }

  List<Transaction> getTransactions() {
    return finalTransactions;
  }
}
