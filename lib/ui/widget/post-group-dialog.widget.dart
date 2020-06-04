import 'package:daruma/model/group.dart';
import 'package:daruma/model/owner.dart';
import 'package:daruma/model/user.dart';
import 'package:daruma/redux/state.dart';
import 'package:daruma/services/bloc/group.bloc.dart';
import 'package:daruma/services/networking/index.dart';
import 'package:daruma/ui/pages/welcome.page.dart';
import 'package:daruma/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sweet_alert_dialogs/sweet_alert_dialogs.dart';

class PostGroupDialog extends StatelessWidget {
  final Group group;

  PostGroupDialog({this.group});

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(converter: (store) {
      return new _ViewModel(
        user: store.state.userState.user,
        tokenId: store.state.userState.tokenUserId,
      );
    }, builder: (BuildContext context, _ViewModel vm) {
      return _postDialogView(context, vm);
    });
  }

  Widget _postDialogView(BuildContext context, _ViewModel vm) {
    final GroupBloc _bloc = GroupBloc();

    Owner owner = new Owner();
    owner.ownerId = vm.user.userId;
    owner.name = vm.user.name;

    _bloc.postGroup(
        Group(
          groupId: group.groupId,
          name: group.name,
          currencyCode: group.currencyCode,
          owner: owner,
          members: group.members,
        ),
        vm.tokenId);

    return StreamBuilder<Response<bool>>(
        stream: _bloc.groupStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.LOADING:
                return RichAlertDialog(
                  alertTitle: richTitle("Cargando"),
                  alertSubtitle: richSubtitle("Se esta creando el grupo..."),
                  alertType: RichAlertType.CUSTOM,
                  dialogIcon: Icon(Icons.access_time, color: redPrimaryColor,),
                );
                break;

              case Status.COMPLETED:
              return RichAlertDialog(
                  alertTitle: richTitle("¡Completado!"),
                  alertSubtitle: richSubtitle("Grupo creado correctamente"),
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
              var errorMessage = snapshot.data.message;
              print("ERROR:" + errorMessage);
              var codeStatus;

              if(errorMessage == "Error During Communication: No Internet connection"){
                codeStatus = 404;
              }
              else{
                codeStatus = int.parse(errorMessage.substring(errorMessage.length-3));
              }

              var errorSubtitle = "Se ha producido un error";

              if(codeStatus == 409){
                errorSubtitle = "Existe un grupo con el mismo nombre";
              }
              else if(codeStatus == 404){
                errorSubtitle = "Error de conexión";
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
  final User user;
  final String tokenId;

  _ViewModel({
    @required this.user,
    @required this.tokenId,
  });
}
