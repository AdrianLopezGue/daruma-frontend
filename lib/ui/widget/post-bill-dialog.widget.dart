import 'package:daruma/model/bill.dart';
import 'package:daruma/model/recurring-bill.dart';
import 'package:daruma/redux/state.dart';
import 'package:daruma/services/bloc/bill.bloc.dart';
import 'package:daruma/services/networking/index.dart';
import 'package:daruma/ui/pages/group.page.dart';
import 'package:daruma/ui/widget/post-recurring-bill-dialog.widget.dart';
import 'package:daruma/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sweet_alert_dialogs/sweet_alert_dialogs.dart';
import 'package:uuid/uuid.dart';

class PostBillDialog extends StatelessWidget {
  final Bill bill;
  final int period;

  PostBillDialog({this.bill, this.period});

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(converter: (store) {
      return new _ViewModel(
        tokenId: store.state.userState.tokenUserId,
      );
    }, builder: (BuildContext context, _ViewModel vm) {
      return _postDialogView(context, vm);
    });
  }

  Widget _postDialogView(BuildContext context, _ViewModel vm) {
    final BillBloc _bloc = BillBloc();

    _bloc.postBill(this.bill, vm.tokenId);

    return StreamBuilder<Response<bool>>(
        stream: _bloc.billStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.LOADING:
                return RichAlertDialog(
                  alertTitle: richTitle("Cargando"),
                  alertSubtitle: richSubtitle("Se esta creando el gasto..."),
                  alertType: RichAlertType.CUSTOM,
                  dialogIcon: Icon(
                    Icons.access_time,
                    color: redPrimaryColor,
                  ),
                );
                break;

              case Status.COMPLETED:
                if (this.period == 0) {
                  return RichAlertDialog(
                    alertTitle: richTitle("¡Completado!"),
                    alertSubtitle: richSubtitle("Gasto creado correctamente"),
                    alertType: RichAlertType.SUCCESS,
                    actions: <Widget>[
                      FlatButton(
                        child: Text("OK"),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return GroupPage();
                              },
                            ),
                          );
                        },
                      )
                    ],
                  );
                } else {
                  var uuid = new Uuid();

                  RecurringBill newRecurringBill = new RecurringBill(
                      id: uuid.v4(),
                      billId: this.bill.billId,
                      groupId: this.bill.groupId,
                      date: this.bill.date,
                      period: this.period);
                      
                  return PostRecurringBillDialog(
                      recurringBill: newRecurringBill);
                }

                break;
              case Status.ERROR:
                return RichAlertDialog(
                  alertTitle: richTitle("Error"),
                  alertSubtitle: richSubtitle("Error creando el gasto"),
                  alertType: RichAlertType.ERROR,
                  actions: <Widget>[
                    FlatButton(
                      child: Text("OK"),
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                    )
                  ],
                );
                break;
            }
          }
          return Container();
        });
  }
}

class _ViewModel {
  final String tokenId;

  _ViewModel({@required this.tokenId});
}
