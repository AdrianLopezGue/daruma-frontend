import 'package:daruma/model/group.dart';
import 'package:daruma/redux/actions.dart';
import 'package:daruma/redux/state.dart';
import 'package:daruma/services/bloc/group.bloc.dart';
import 'package:daruma/services/networking/index.dart';
import 'package:daruma/ui/pages/group.page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

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
                return Center(child: CircularProgressIndicator());
                break;

              case Status.COMPLETED:
                return Container(
                  height: 300.0, // Change as per your requirement
                  width: 300.0,
                  child: Row(
                    children: <Widget>[
                      Text("Update completed!"),
                      FlatButton(
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
                        child: Text(
                          "Exit",
                        ),
                      )
                    ],
                  ),
                );
                break;
              case Status.ERROR:
                return Container(
                  height: 300.0, // Change as per your requirement
                  width: 300.0,
                  child: Row(
                    children: <Widget>[
                      Text("Update ERROR!"),
                      FlatButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child: Text(
                          "Exit",
                        ),
                      )
                    ],
                  ),
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
