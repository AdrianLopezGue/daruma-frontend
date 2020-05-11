import 'package:daruma/model/group.dart';
import 'package:daruma/redux/index.dart';
import 'package:daruma/ui/widget/bills-list.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class BillsHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel(
          group: store.state.groupState.group,
          tokenId: store.state.userState.tokenUserId),
      builder: (BuildContext context, _ViewModel vm) =>
          _historyView(context, vm),
    );
  }

  Widget _historyView(BuildContext context, _ViewModel vm) {
    return Scaffold(
        body: SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  BillsList(tokenId: vm.tokenId, group: vm.group),
                ],
              )
            ],
          ),
        ),
      ),
    ));
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
