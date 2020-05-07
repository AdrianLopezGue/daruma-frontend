import 'package:daruma/model/group.dart';
import 'package:daruma/redux/actions.dart';
import 'package:daruma/redux/state.dart';
import 'package:daruma/services/bloc/group.bloc.dart';
import 'package:daruma/services/networking/index.dart';
import 'package:daruma/ui/pages/group.page.dart';
import 'package:daruma/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sweet_alert_dialogs/sweet_alert_dialogs.dart';

class EditGroupDialog extends StatelessWidget {
  final String name;
  final String currencyCode;

  EditGroupDialog({this.name, this.currencyCode});

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(converter: (store) {
      return new _ViewModel(
          group: store.state.groupState.group,
          tokenId: store.state.userState.tokenUserId,
          updateGroup: () {
            store.dispatch(GroupUpdatedAction(name, currencyCode));
          });
    }, builder: (BuildContext context, _ViewModel vm) {
      return _editGroupNameDialogView(context, vm);
    });
  }

  Widget _editGroupNameDialogView(BuildContext context, _ViewModel vm) {
    final GroupBloc _bloc = GroupBloc();

    _bloc.updateGroup(vm.group.groupId, name, currencyCode, vm.tokenId);

    return StreamBuilder<Response<bool>>(
        stream: _bloc.groupStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.LOADING:
              return RichAlertDialog(
                  alertTitle: richTitle("Cargando"),
                  alertSubtitle: richSubtitle("Se esta editando el grupo..."),
                  alertType: RichAlertType.CUSTOM,
                  dialogIcon: Icon(Icons.access_time, color: redPrimaryColor,),
                );
                break;

              case Status.COMPLETED:
              return RichAlertDialog(
                  alertTitle: richTitle("¡Completado!"),
                  alertSubtitle: richSubtitle("Group editado correctamente"),
                  alertType: RichAlertType.SUCCESS,
                  actions: <Widget>[
                    FlatButton(
                      child: Text("OK"),
                      onPressed: () {
                        vm.updateGroup();
                          Navigator.pop(context, true);
                          Navigator.pop(context, true);
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
  final Group group;
  final String tokenId;
  final Function updateGroup;

  _ViewModel({
    @required this.group,
    @required this.tokenId,
    @required this.updateGroup,
  });
}
