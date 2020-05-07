import 'package:daruma/model/member.dart';
import 'package:daruma/redux/index.dart';
import 'package:daruma/redux/state.dart';
import 'package:daruma/services/bloc/member.bloc.dart';
import 'package:daruma/services/networking/index.dart';
import 'package:daruma/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sweet_alert_dialogs/sweet_alert_dialogs.dart';

class AddMemberDialog extends StatelessWidget {
  final Member member;
  final String groupId;

  AddMemberDialog({this.member, this.groupId});

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(converter: (store) {
      return new _ViewModel(
          tokenId: store.state.userState.tokenUserId,
          addMember: (Member newMember) {
            store.dispatch(AddMemberToGroupAction(newMember));
          });
    }, builder: (BuildContext context, _ViewModel vm) {
      return _addMemberDialogView(context, vm);
    });
  }

  Widget _addMemberDialogView(BuildContext context, _ViewModel vm) {
    final MemberBloc _bloc = MemberBloc();

    _bloc.addMember(this.member, this.groupId, vm.tokenId);

    return StreamBuilder<Response<bool>>(
        stream: _bloc.memberStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.LOADING:
                return RichAlertDialog(
                  alertTitle: richTitle("Cargando"),
                  alertSubtitle: richSubtitle("Añadiendo miembro..."),
                  alertType: RichAlertType.CUSTOM,
                  dialogIcon: Icon(Icons.access_time, color: redPrimaryColor,),
                );
                break;

              case Status.COMPLETED:
              return RichAlertDialog(
                  alertTitle: richTitle("¡Completado!"),
                  alertSubtitle: richSubtitle("Miembro añadido correctamente"),
                  alertType: RichAlertType.SUCCESS,
                  actions: <Widget>[
                    FlatButton(
                      child: Text("OK"),
                      onPressed: () {
                        vm.addMember(this.member);
                          Navigator.of(context).pop();
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
                errorSubtitle = "No se puede añadir un miembro en un grupo desconocido";
              } else if(codeStatus == 409){
                errorSubtitle = "Existe un miembro con el mismo nombre";
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
  final Function(Member) addMember;

  _ViewModel({
    @required this.tokenId,
    @required this.addMember,
  });
}
