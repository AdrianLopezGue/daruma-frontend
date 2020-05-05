import 'package:daruma/model/transaction.dart';
import 'package:daruma/redux/state.dart';
import 'package:daruma/services/bloc/transaction.bloc.dart';
import 'package:daruma/services/networking/index.dart';
import 'package:daruma/ui/pages/group.page.dart';
import 'package:daruma/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sweet_alert_dialogs/sweet_alert_dialogs.dart';
import 'package:url_launcher/url_launcher.dart';

class PostTransferDialog extends StatelessWidget {
  final Transaction transaction;
  final String paypalName;

  PostTransferDialog({this.transaction, this.paypalName});

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
    final TransactionBloc _bloc = TransactionBloc();

    _bloc.postTransaction(this.transaction, vm.tokenId);

    return StreamBuilder<Response<bool>>(
        stream: _bloc.transactionStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.LOADING:
                return RichAlertDialog(
                  alertTitle: richTitle("Cargando"),
                  alertSubtitle: richSubtitle("Se esta liquidando el gasto..."),
                  alertType: RichAlertType.CUSTOM,
                  dialogIcon: Icon(
                    Icons.access_time,
                    color: redPrimaryColor,
                  ),
                );
                break;

              case Status.COMPLETED:
                String dialogSubtitle = "Liquidación realizada correctamente";

                if (this.paypalName.isNotEmpty) {
                  dialogSubtitle = "Puedes pagar con paypal al beneficiario";
                }

                return RichAlertDialog(
                  alertTitle: richTitle("¡Liquidación completada!"),
                  alertSubtitle: richSubtitle(dialogSubtitle),
                  alertType: RichAlertType.SUCCESS,
                  actions: <Widget>[
                    this.paypalName.isNotEmpty
                        ? FlatButton(
                            color: Color.fromRGBO(59, 123, 191, 1),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40)),
                            child: Text("Pagar con paypal",
                                style: GoogleFonts.roboto(
                                    textStyle:
                                        TextStyle(fontSize: 18, color: white))),
                            onPressed: () {
                              launch('https://www.paypal.me/' + this.paypalName + "/" + (this.transaction.money/100).toString() + this.transaction.currencyCode);
                              
                            },
                          )
                        : Container(),
                    this.paypalName.isNotEmpty
                        ? SizedBox(
                            width: 20.0,
                          )
                        : Container(),
                    FlatButton(
                      color: greenSuccess,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)),
                      child: Text("OK",
                          style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                  fontSize: 18, color: Colors.white))),
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
                var codeStatus =
                    int.parse(errorMessage.substring(errorMessage.length - 3));

                var errorSubtitle = "Se ha producido un error";

                if (codeStatus == 400) {
                  errorSubtitle =
                      "El endeudado no puede ser el mismo que el beneficiario (Error: 400)";
                } else if (codeStatus == 404) {
                  errorSubtitle =
                      "Alguno de los datos enviados no fueron encontrados (Error: 404)";
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

  _ViewModel({@required this.tokenId});
}
