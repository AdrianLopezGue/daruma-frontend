import 'dart:async';

import 'package:daruma/model/bill.dart';
import 'package:daruma/model/recurring-bill.dart';
import 'package:daruma/services/networking/index.dart';
import 'package:daruma/services/repository/bill.repository.dart';
import 'package:rxdart/rxdart.dart';

class BillBloc {
  BillRepository _billRepository;
  StreamController _billController;
  StreamController _billControllerGroups;
  StreamController _recurringBillController;

  StreamSink<Response<bool>> get billSink => _billController.sink;
  Stream<Response<bool>> get billStream => _billController.stream;

  StreamSink<Response<List<Bill>>> get billSinkBills =>
      _billControllerGroups.sink;
  Stream<Response<List<Bill>>> get billStreamBills =>
      _billControllerGroups.stream;

  StreamSink<Response<List<RecurringBill>>> get billSinkRecurringBills =>
      _recurringBillController.sink;
  Stream<Response<List<RecurringBill>>> get billStreamRecurringBills =>
      _recurringBillController.stream;

  BillBloc() {
    _billController = BehaviorSubject<Response<bool>>();
    _billRepository = BillRepository();
    _billControllerGroups = BehaviorSubject<Response<List<Bill>>>();
    _recurringBillController = BehaviorSubject<Response<List<RecurringBill>>>();
  }

  postBill(Bill bill, String tokenId) async {
    billSink.add(Response.loading('Post new bill.'));
    try {
      bool billResponse = await _billRepository.createBill(bill, tokenId);
      billSink.add(Response.completed(billResponse));
    } catch (e) {
      billSink.add(Response.error(e.toString()));
      print(e);
    }
  }

  postRecurringBill(RecurringBill recurringBill, String tokenId) async {
    billSink.add(Response.loading('Post new recurring bill.'));
    try {
      bool billResponse = await _billRepository.createRecurringBill(recurringBill, tokenId);
      billSink.add(Response.completed(billResponse));
    } catch (e) {
      billSink.add(Response.error(e.toString()));
      print(e);
    }
  }

  deleteBill(String billId, String tokenId) async {
    billSink.add(Response.loading('Delete bill.'));
    try {
      bool billResponse = await _billRepository.deleteBill(billId, tokenId);
      billSink.add(Response.completed(billResponse));
    } catch (e) {
      billSink.add(Response.error(e.toString()));
      print(e);
    }
  }

  deleteRecurringBill(String billId, String tokenId) async {
    billSink.add(Response.loading('Delete recurring bill.'));
    try {
      bool billResponse = await _billRepository.deleteRecurringBill(billId, tokenId);
      billSink.add(Response.completed(billResponse));
    } catch (e) {
      billSink.add(Response.error(e.toString()));
      print(e);
    }
  }

  updateBill(Bill bill, String tokenId) async {
    billSink.add(Response.loading('Update bill.'));
    try {
      bool billResponse =
          await _billRepository.updateBill(bill, tokenId);
      billSink.add(Response.completed(billResponse));
    } catch (e) {
      billSink.add(Response.error(e.toString()));
      print(e);
    }
  }

  updateRecurringBill(String recurringBillId, int period, String tokenId) async {
    billSink.add(Response.loading('Update recurring bill.'));
    try {
      bool billResponse =
          await _billRepository.updateRecurringBill(recurringBillId, period, tokenId);
      billSink.add(Response.completed(billResponse));
    } catch (e) {
      billSink.add(Response.error(e.toString()));
      print(e);
    }
  }

  getBills(String groupId, String tokenId) async {
    billSinkBills.add(Response.loading('Get bills.'));
    try {
      List<Bill> billResponse =
          await _billRepository.getBills(groupId, tokenId);

      billSinkBills.add(Response.completed(billResponse));
    } catch (e) {
      billSinkBills.add(Response.error(e.toString()));
      print(e);
    }
  }

  getRecurringBills(String groupId, String tokenId) async {
    billSinkRecurringBills.add(Response.loading('Get recurring bills.'));
    try {
      List<RecurringBill> billResponse =
          await _billRepository.getRecurringBills(groupId, tokenId);

      billSinkRecurringBills.add(Response.completed(billResponse));
    } catch (e) {
      billSinkRecurringBills.add(Response.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _billController?.close();
    _billControllerGroups?.close();
    _recurringBillController?.close();
  }

}
