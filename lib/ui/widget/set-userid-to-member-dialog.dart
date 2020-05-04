import 'package:daruma/redux/state.dart';
import 'package:daruma/services/bloc/member.bloc.dart';
import 'package:daruma/services/networking/index.dart';
import 'package:daruma/ui/pages/welcome.page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class SetUserIdToMemberDialog extends StatelessWidget {
  final String idMember;
  final String idUser;

  SetUserIdToMemberDialog({ this.idMember, this.idUser });

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(converter: (store) {
      return new _ViewModel(
        idToken: store.state.userState.idTokenUser,
      );
    }, builder: (BuildContext context, _ViewModel vm) {
      return _selectMemberInGroupDialogView(context, vm);
    });
  }

  Widget _selectMemberInGroupDialogView(BuildContext context, _ViewModel vm) {
    final MemberBloc _bloc = MemberBloc();

    _bloc.setUserIdToMember(
        this.idMember,
        this.idUser,
        vm.idToken);

    return StreamBuilder<Response<bool>>(
        stream: _bloc.memberStream,
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
                      Text("Set Id completed!"),
                      FlatButton(
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
                      Text("Set Id ERROR!"),
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
  final String idToken;

  _ViewModel({
    @required this.idToken,
  });
}