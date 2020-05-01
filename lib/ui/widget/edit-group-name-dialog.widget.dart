import 'package:daruma/model/group.dart';
import 'package:daruma/redux/actions.dart';
import 'package:daruma/redux/state.dart';
import 'package:daruma/services/bloc/group.bloc.dart';
import 'package:daruma/services/networking/index.dart';
import 'package:daruma/ui/pages/welcome.page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class EditGroupNameDialog extends StatelessWidget {
  final String name;

  EditGroupNameDialog({this.name});

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(converter: (store) {
      return new _ViewModel(
        group: store.state.groupState.group,
        idToken: store.state.userState.idTokenUser,
        updateGroupName: () {
          store.dispatch(GroupNameUpdatedAction(name));
        }
      );
    }, builder: (BuildContext context, _ViewModel vm) {
      return _editGroupNameDialogView(context, vm);
    });
  }

  Widget _editGroupNameDialogView(BuildContext context, _ViewModel vm) {
    final GroupBloc _bloc = GroupBloc();

    _bloc.updateGroupName(
        vm.group.idGroup,
        name,
        vm.idToken);

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
                          vm.updateGroupName();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return WelcomeScreen();
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
  final String idToken;
  final Function updateGroupName;

  _ViewModel({
    @required this.group,
    @required this.idToken,
    @required this.updateGroupName,
  });
}
