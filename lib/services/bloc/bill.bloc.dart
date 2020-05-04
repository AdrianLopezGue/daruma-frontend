import 'dart:async';

import 'package:daruma/model/bill.dart';
import 'package:daruma/services/networking/index.dart';
import 'package:daruma/services/repository/bill.repository.dart';
import 'package:rxdart/rxdart.dart';

class BillBloc {
  BillRepository _billRepository;
  StreamController _billController;
  StreamController _billControllerGroups;

  StreamSink<Response<bool>> get billSink => _billController.sink;
  Stream<Response<bool>> get billStream => _billController.stream;

  StreamSink<Response<List<Bill>>> get billSinkBills =>
      _billControllerGroups.sink;
  Stream<Response<List<Bill>>> get billStreamBills =>
      _billControllerGroups.stream;

  BillBloc() {
    _billController = BehaviorSubject<Response<bool>>();
    _billRepository = BillRepository();
    _billControllerGroups = BehaviorSubject<Response<List<Bill>>>();
  }

  postBill(Bill bill, String idToken) async {
    billSink.add(Response.loading('Post new bill.'));
    try {
      bool billResponse = await _billRepository.createBill(bill, idToken);
      billSink.add(Response.completed(billResponse));
    } catch (e) {
      billSink.add(Response.error(e.toString()));
      print(e);
    }
  }

  deleteBill(String idBill, String idToken) async {
    billSink.add(Response.loading('Delete bill.'));
    try {
      bool billResponse = await _billRepository.deleteBill(idBill, idToken);
      billSink.add(Response.completed(billResponse));
    } catch (e) {
      billSink.add(Response.error(e.toString()));
      print(e);
    }
  }

  getBills(String idGroup, String idToken) async {
    billSinkBills.add(Response.loading('Get bills.'));
    try {
      List<Bill> billResponse =
          await _billRepository.getBills(idGroup, idToken);

      billSinkBills.add(Response.completed(billResponse));
    } catch (e) {
      billSinkBills.add(Response.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _billController?.close();
    _billControllerGroups?.close();
  }
}
