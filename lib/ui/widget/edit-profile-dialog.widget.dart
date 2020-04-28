import 'package:daruma/model/user.dart';
import 'package:daruma/redux/actions.dart';
import 'package:daruma/redux/state.dart';
import 'package:daruma/services/bloc/user.bloc.dart';
import 'package:daruma/services/networking/index.dart';
import 'package:daruma/ui/pages/welcome.page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class EditProfileDialog extends StatelessWidget {
  final String name;
  final String paypal;

  EditProfileDialog({this.name, this.paypal});

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(converter: (store) {
      return new _ViewModel(
        user: store.state.userState.user,
        idToken: store.state.userState.idTokenUser,
        updateUser: () {
          store.dispatch(UserUpdatedAction(name, paypal));
        }
      );
    }, builder: (BuildContext context, _ViewModel vm) {
      return _editProfileDialogView(context, vm);
    });
  }

  Widget _editProfileDialogView(BuildContext context, _ViewModel vm) {
    final UserBloc _bloc = UserBloc();

    _bloc.updateUser(
        vm.user.idUser,
        name,
        paypal,
        vm.idToken);

    return StreamBuilder<Response<bool>>(
        stream: _bloc.userStream,
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
                      Text("Post completed!"),
                      FlatButton(
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
                      Text("Post ERROR!"),
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
  final User user;
  final String idToken;
  final Function updateUser;

  _ViewModel({
    @required this.user,
    @required this.idToken,
    @required this.updateUser,
  });
}
