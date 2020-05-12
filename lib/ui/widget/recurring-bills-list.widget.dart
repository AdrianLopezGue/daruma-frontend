import 'package:daruma/model/bill.dart';
import 'package:daruma/model/group.dart';
import 'package:daruma/model/recurring-bill.dart';
import 'package:daruma/redux/index.dart';
import 'package:daruma/services/bloc/bill.bloc.dart';
import 'package:daruma/services/networking/response.dart';
import 'package:daruma/ui/pages/detail-recurring-bill.page.dart';
import 'package:daruma/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';

class RecurringBillsList extends StatelessWidget {
  final List<Bill> bills;

  RecurringBillsList({this.bills});

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel(
          group: store.state.groupState.group,
          tokenId: store.state.userState.tokenUserId),
      builder: (BuildContext context, _ViewModel vm) =>
          _recurrenctBillsListView(context, vm),
    );
  }

  Widget _recurrenctBillsListView(BuildContext context, _ViewModel vm) {
    final BillBloc _bloc = BillBloc();
    _bloc.getRecurringBills(vm.group.groupId, vm.tokenId);

    return StreamBuilder<Response<List<RecurringBill>>>(
        stream: _bloc.billStreamRecurringBills,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.LOADING:
                return Center(child: CircularProgressIndicator());
                break;

              case Status.COMPLETED:
                return Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data.data.length,
                        itemBuilder: (context, index) {
                          Bill specificBill;

                          for(int i = 0; i<this.bills.length; i++){
                            if(this.bills[i].billId == snapshot.data.data[index].billId){
                              specificBill = this.bills[i];
                            }
                          }
                          
                          return specificBill != null ? _buildListTile(
                              snapshot.data.data[index], specificBill, vm.group, context) : Container();
                        }));
                break;
              case Status.ERROR:
                return Card(
                  color: redPrimaryColor,
                  child: Text(
                    "Error recibiendo gastos recurrentes",
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

  Card _buildListTile(RecurringBill recurringBill, Bill bill, Group group, BuildContext context) {

    return Card(
          child: Padding(
            padding: const EdgeInsets.only(left:10.0, right: 10.0),
            child: ListTile(
        contentPadding: const EdgeInsets.only(top: 0.0),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.access_time, size: 35.0),
        ),
        title: Text(bill.name),
        subtitle: Text("Se cobrará el " + recurringBill.nextCreationDate.toIso8601String().substring(0, 10)),
        onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return DetailRecurringBillPage(
                      recurringBill: recurringBill, bill: bill, group: group);
                },
              ),
            );
        },
      ),
          ),
    );
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