import 'package:daruma/redux/state.dart';
import 'package:daruma/services/bloc/bill.bloc.dart';
import 'package:daruma/services/networking/index.dart';
import 'package:daruma/ui/pages/group.page.dart';
import 'package:daruma/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sweet_alert_dialogs/sweet_alert_dialogs.dart';

class DeleteRecurringBillDialog extends StatelessWidget {
  final String recurringBillId;

  DeleteRecurringBillDialog({this.recurringBillId});

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(converter: (store) {
      return new _ViewModel(
        tokenId: store.state.userState.tokenUserId,
      );
    }, builder: (BuildContext context, _ViewModel vm) {
      return _deleteRecurringBillDialogView(context, vm);
    });
  }

  Widget _deleteRecurringBillDialogView(BuildContext context, _ViewModel vm) {
    final BillBloc _bloc = BillBloc();

    _bloc.deleteRecurringBill(this.recurringBillId, vm.tokenId);

    return StreamBuilder<Response<bool>>(
        stream: _bloc.billStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.LOADING:
              return RichAlertDialog(
                  alertTitle: richTitle("Cargando"),
                  alertSubtitle: richSubtitle("Se esta eliminando el gasto recurrente..."),
                  alertType: RichAlertType.CUSTOM,
                  dialogIcon: Icon(Icons.access_time, color: redPrimaryColor,),
                );
                break;

              case Status.COMPLETED:
              return RichAlertDialog(
                  alertTitle: richTitle("¡Completado!"),
                  alertSubtitle: richSubtitle("Gasto recurrente eliminado correctamente"),
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
                break;
              case Status.ERROR:
              var errorMessage = snapshot.data.message;
              var codeStatus = int.parse(errorMessage.substring(errorMessage.length-3));

              var errorSubtitle = "Se ha producido un error";

              if(codeStatus == 404){
                errorSubtitle = "Gasto no encontrado";
              }
              
              return RichAlertDialog(
                  alertTitle: richTitle("Error"),
                  alertSubtitle: richSubtitle(errorSubtitle),
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

  _ViewModel({
    @required this.tokenId,
  });
}
