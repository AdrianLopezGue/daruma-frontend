import 'package:daruma/model/group.dart';
import 'package:daruma/redux/index.dart';
import 'package:daruma/services/bloc/group-bloc.dart';
import 'package:daruma/services/networking/index.dart';
import 'package:daruma/util/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:daruma/ui/pages/login.dart';
import 'package:flutter_redux/flutter_redux.dart';

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(converter: (store) {
      return new _ViewModel(
        user: store.state.firebaseState.firebaseUser,
        idToken: store.state.firebaseState.idTokenUser,
        logout: () {
          store.dispatch(LogoutAction());
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) {
            return LoginPage();
          }), ModalRoute.withName('/'));
        },
      );
    }, builder: (BuildContext context, _ViewModel vm) {
      return _loginView(context, vm);
    });
  }

  Widget _loginView(BuildContext context, _ViewModel vm) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: white),
        child: Column(          
          children: <Widget>[
            SizedBox(height: 40),
            SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(                                       
                    children: <Widget>[
                      Text(
                        'Bienvenido,',
                        style: TextStyle(
                            fontSize: 30,
                            color: black),
                      ),
                      Text(
                        vm.user.displayName,
                        style: TextStyle(
                            fontSize: 20,
                            color: redPrimaryColor,),
                      ),
                    ],
                  ),
                ),
            ),
            SizedBox(height: 40),
            RaisedButton(
              onPressed: () {
                vm.logout();
              },
              color: redPrimaryColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Sign Out',
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
              ),
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)),
            ),
            SizedBox(height: 40),
            RaisedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  child: new SimpleDialog(children: <Widget>[
                    GroupsDialog(user: vm.user, idToken: vm.idToken),
                  ]));
              },
              color: redPrimaryColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Show groups',
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
              ),
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: redPrimaryColor,
        onPressed: () {
          showDialog(
              context: context,
              child: new SimpleDialog(children: <Widget>[
                LoadingDialog(user: vm.user, idToken: vm.idToken),
              ]));
        },
      ),
    );
  }
}

class _ViewModel {
  final FirebaseUser user;
  final String idToken;
  final Function() logout;

  _ViewModel({
    @required this.user,
    @required this.idToken,
    @required this.logout,
  });
}

class LoadingDialog extends StatelessWidget {
  final FirebaseUser user;
  final String idToken;

  LoadingDialog({this.user, this.idToken});

  @override
  Widget build(BuildContext context) {
    final GroupBloc _bloc = GroupBloc();

    _bloc.postGroup(
        Group(name: "Grupo prueba", currencyCode: "EUR", idOwner: user.uid),
        idToken);

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
                      Text("Post completed!"),
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

class GroupsDialog extends StatelessWidget {
  final FirebaseUser user;
  final String idToken;

  GroupsDialog({this.user, this.idToken});

  @override
  Widget build(BuildContext context) {
    final GroupBloc _bloc = GroupBloc();

    _bloc.getGroups(idToken);

    return StreamBuilder<Response<List<Group>>>(
        stream: _bloc.groupStreamGroups,
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
                  child: ListView.builder(
                      itemCount: snapshot.data.data.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                              snapshot.data.data[index].name),
                          subtitle: Text(
                              snapshot.data.data[index].currencyCode),
                          onTap: (){
                            Navigator.pop(context, true);
                          } 
                        );
                      })
                );
                break;
                case Status.ERROR:
                return Container(
                  height: 300.0, // Change as per your requirement
                  width: 300.0,
                  child: Row(
                    children: <Widget>[
                      Text("GET ERROR!"),
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