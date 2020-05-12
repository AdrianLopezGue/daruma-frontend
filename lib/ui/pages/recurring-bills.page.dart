import 'package:daruma/model/bill.dart';
import 'package:daruma/model/group.dart';
import 'package:daruma/redux/index.dart';
import 'package:daruma/services/bloc/bill.bloc.dart';
import 'package:daruma/services/networking/index.dart';
import 'package:daruma/ui/widget/recurring-bills-list.widget.dart';
import 'package:daruma/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';

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

    final BillBloc _bloc = BillBloc();
    _bloc.getBills(vm.group.groupId, vm.tokenId);

    return StreamBuilder<Response<List<Bill>>>(
        stream: _bloc.billStreamBills,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.LOADING:
                return Center(child: CircularProgressIndicator());
                break;

              case Status.COMPLETED:
                return Scaffold(
                    body: SingleChildScrollView(
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              RecurringBillsList(bills: snapshot.data.data),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ));
                break;
              case Status.ERROR:
                return Card(
                  color: redPrimaryColor,
                  child: Text(
                    "Error recibiendo gastos",
                    style: GoogleFonts.roboto(
                        fontSize: 22, textStyle: TextStyle(color: white)),
                  ),
                );
                break;
            }
          }
          return Container();
        });
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