import 'package:daruma/model/member.dart';
import 'package:daruma/redux/state.dart';
import 'package:daruma/redux/index.dart';
import 'package:daruma/services/bloc/member.bloc.dart';
import 'package:daruma/services/networking/index.dart';
import 'package:daruma/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sweet_alert_dialogs/sweet_alert_dialogs.dart';

class DeleteMemberDialog extends StatelessWidget {
  final Member member;

  DeleteMemberDialog({this.member});

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(converter: (store) {
      return new _ViewModel(
          tokenId: store.state.userState.tokenUserId,
          deleteMember: (Member deletedMember) {
            store.dispatch(DeleteMemberToGroupAction(deletedMember));
          });
    }, builder: (BuildContext context, _ViewModel vm) {
      return _deleteMemberDialogView(context, vm);
    });
  }

  Widget _deleteMemberDialogView(BuildContext context, _ViewModel vm) {
    final MemberBloc _bloc = MemberBloc();

    _bloc.deleteMember(this.member.memberId, vm.tokenId);

    return StreamBuilder<Response<bool>>(
        stream: _bloc.memberStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.LOADING:
              return RichAlertDialog(
                  alertTitle: richTitle("Cargando"),
                  alertSubtitle: richSubtitle("Se esta eliminado el miembro..."),
                  alertType: RichAlertType.CUSTOM,
                  dialogIcon: Icon(Icons.access_time, color: redPrimaryColor,),
                );
                break;

              case Status.COMPLETED:
              return RichAlertDialog(
                  alertTitle: richTitle("¡Completado!"),
                  alertSubtitle: richSubtitle("Miembro eliminado correctamente"),
                  alertType: RichAlertType.SUCCESS,
                  actions: <Widget>[
                    FlatButton(
                      child: Text("OK"),
                      onPressed: () {
                        vm.deleteMember(this.member);
                          Navigator.of(context).pop();
                      },
                    )
                  ],
                );
                break;
              case Status.ERROR:
              var errorMessage = snapshot.data.message;
              var codeStatus = int.parse(errorMessage.substring(31, 34));

              var errorSubtitle = "Se ha producido un error";

              if(codeStatus == 403){
                errorSubtitle = "No te puedes eliminar a ti mismo";
              } else if(codeStatus == 404){
                errorSubtitle = "No se puede eliminar ";
              } else if(codeStatus == 400){
                errorSubtitle = "El miembro está involucrado en un gasto";
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
  final Function(Member) deleteMember;

  _ViewModel({
    @required this.tokenId,
    @required this.deleteMember,
  });
}
