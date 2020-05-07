import 'package:daruma/redux/state.dart';
import 'package:daruma/services/bloc/group.bloc.dart';
import 'package:daruma/services/networking/index.dart';
import 'package:daruma/ui/pages/welcome.page.dart';
import 'package:daruma/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sweet_alert_dialogs/sweet_alert_dialogs.dart';

class DeleteDialog extends StatelessWidget {
  final String groupId;

  DeleteDialog({this.groupId});

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(converter: (store) {
      return new _ViewModel(
        tokenId: store.state.userState.tokenUserId,
      );
    }, builder: (BuildContext context, _ViewModel vm) {
      return _deleteDialogView(context, vm);
    });
  }

  Widget _deleteDialogView(BuildContext context, _ViewModel vm) {
    final GroupBloc _bloc = GroupBloc();

    _bloc.deleteGroup(this.groupId, vm.tokenId);

    return StreamBuilder<Response<bool>>(
        stream: _bloc.groupStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.LOADING:
                return RichAlertDialog(
                  alertTitle: richTitle("Cargando"),
                  alertSubtitle: richSubtitle("Se esta eliminando el grupo..."),
                  alertType: RichAlertType.CUSTOM,
                  dialogIcon: Icon(Icons.access_time, color: redPrimaryColor,),
                );
                break;

              case Status.COMPLETED:
              return RichAlertDialog(
                  alertTitle: richTitle("¡Completado!"),
                  alertSubtitle: richSubtitle("Grupo eliminado correctamente"),
                  alertType: RichAlertType.SUCCESS,
                  actions: <Widget>[
                    FlatButton(
                      child: Text("OK"),
                      onPressed: () {
                        Navigator.pop(context, true);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return WelcomeScreen();
                            },
                          ),
                        );
                      },
                    )
                  ],
                );
                break;
              case Status.ERROR:
              var errorSubtitle = "Se ha producido un error";
              
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
