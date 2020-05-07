import 'package:daruma/model/user.dart';
import 'package:daruma/redux/actions.dart';
import 'package:daruma/redux/state.dart';
import 'package:daruma/services/bloc/user.bloc.dart';
import 'package:daruma/services/networking/index.dart';
import 'package:daruma/ui/pages/welcome.page.dart';
import 'package:daruma/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sweet_alert_dialogs/sweet_alert_dialogs.dart';

class EditProfileDialog extends StatelessWidget {
  final String name;
  final String paypal;

  EditProfileDialog({this.name, this.paypal});

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(converter: (store) {
      return new _ViewModel(
          user: store.state.userState.user,
          tokenId: store.state.userState.tokenUserId,
          updateUser: () {
            store.dispatch(UserUpdatedAction(name, paypal));
          });
    }, builder: (BuildContext context, _ViewModel vm) {
      return _editProfileDialogView(context, vm);
    });
  }

  Widget _editProfileDialogView(BuildContext context, _ViewModel vm) {
    final UserBloc _bloc = UserBloc();

    _bloc.updateUser(vm.user.userId, name, paypal, vm.tokenId);

    return StreamBuilder<Response<bool>>(
        stream: _bloc.userStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.LOADING:
              return RichAlertDialog(
                  alertTitle: richTitle("Cargando"),
                  alertSubtitle: richSubtitle("Se esta editando el perfil..."),
                  alertType: RichAlertType.CUSTOM,
                  dialogIcon: Icon(Icons.access_time, color: redPrimaryColor,),
                );
                break;

              case Status.COMPLETED:
              return RichAlertDialog(
                  alertTitle: richTitle("¡Completado!"),
                  alertSubtitle: richSubtitle("Perfil editado correctamente"),
                  alertType: RichAlertType.SUCCESS,
                  actions: <Widget>[
                    FlatButton(
                      child: Text("OK"),
                      onPressed: () {
                        vm.updateUser();
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

              var errorSubtitle = "No se ha encontrado al usuario";

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
  final User user;
  final String tokenId;
  final Function updateUser;

  _ViewModel({
    @required this.user,
    @required this.tokenId,
    @required this.updateUser,
  });
}
