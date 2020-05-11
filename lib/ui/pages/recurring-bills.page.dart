import 'package:daruma/model/bill.dart';
import 'package:daruma/model/group.dart';
import 'package:daruma/redux/index.dart';
import 'package:daruma/services/repository/bill.repository.dart';
import 'package:daruma/ui/widget/recurring-bills-list.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class RecurringBills extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel(
          group: store.state.groupState.group,
          tokenId: store.state.userState.tokenUserId),
      builder: (BuildContext context, _ViewModel vm) =>
          _recurrenctBillsView(context, vm),
    );
  }

  Widget _recurrenctBillsView(BuildContext context, _ViewModel vm) {
    return Scaffold(
        body: SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  RecurringBillsList(tokenId: vm.tokenId, group: vm.group),
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }

  Future<List<Bill>> _getBills(String groupId, String tokenId ) async {
    var billRepository = new BillRepository();
    var bills = await billRepository.getBills(groupId, tokenId);

    return bills;
  }
}

class _ViewModel {
  final Group group;
  final String tokenId;

  _ViewModel({
    @required this.group,
    @required this.tokenId,
  });
}