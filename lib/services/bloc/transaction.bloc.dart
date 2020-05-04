import 'dart:async';
import 'package:daruma/model/transaction.dart';
import 'package:daruma/services/networking/index.dart';
import 'package:daruma/services/repository/transaction.repository.dart';
import 'package:rxdart/subjects.dart';

class TransactionBloc {
  TransactionRepository _transactionRepository;
  StreamController _transactionController;

  StreamSink<Response<bool>> get transactionSink => _transactionController.sink;

  Stream<Response<bool>> get transactionStream => _transactionController.stream;

  TransactionBloc() {
    _transactionController = BehaviorSubject<Response<bool>>();
    _transactionRepository = TransactionRepository();
  }

  postTransaction(Transaction transaction, String idToken) async {
    transactionSink.add(Response.loading('Post new transaction.'));
    try {
      bool transactionResponse =
          await _transactionRepository.createTransfer(transaction, idToken);
      transactionSink.add(Response.completed(transactionResponse));
    } catch (e) {
      transactionSink.add(Response.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _transactionController?.close();
  }
}
