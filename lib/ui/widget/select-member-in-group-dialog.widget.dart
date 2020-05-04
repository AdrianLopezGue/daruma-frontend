import 'package:daruma/model/member.dart';
import 'package:daruma/redux/state.dart';
import 'package:daruma/services/bloc/member.bloc.dart';
import 'package:daruma/services/networking/index.dart';
import 'package:daruma/ui/widget/set-userid-to-member-dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class SelectMemberInGroupDialog extends StatefulWidget {
  final String idGroup;

  SelectMemberInGroupDialog({this.idGroup});

  @override
  _SelectMemberInGroupDialogState createState() =>
      _SelectMemberInGroupDialogState();
}

class _SelectMemberInGroupDialogState extends State<SelectMemberInGroupDialog> {
  bool memberSelected = false;
  String idMemberSelected = '';
  String idUserSelected = '';

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(converter: (store) {
      return new _ViewModel(
        idToken: store.state.userState.idTokenUser,
        idUser: store.state.userState.user.idUser,
      );
    }, builder: (BuildContext context, _ViewModel vm) {
      return _selectMemberInGroupDialogView(context, vm);
    });
  }

  Widget _selectMemberInGroupDialogView(BuildContext context, _ViewModel vm) {
    final MemberBloc _bloc = MemberBloc();

    _bloc.getMembers(this.widget.idGroup, vm.idToken);

    return StreamBuilder<Response<List<Member>>>(
        stream: _bloc.memberStreamMembers,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.LOADING:
                return Center(child: CircularProgressIndicator());
                break;

              case Status.COMPLETED:
                if (memberSelected == false) {
                  var memberInGroup = snapshot.data.data
                      .where((member) => member.idUser == vm.idUser);

                  if (memberInGroup.isEmpty) {
                    return Container(
                      height: 300.0,
                      width: 300.0,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: ListView.builder(
                              itemCount: snapshot.data.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                if (snapshot.data.data[index].idUser.isEmpty) {
                                  return ListTile(
                                    title: Text(snapshot.data.data[index].name),
                                    onTap: () {
                                      setState(() {
                                        memberSelected = true;
                                        idMemberSelected =
                                            snapshot.data.data[index].idMember;
                                        idUserSelected = vm.idUser;
                                      });
                                    },
                                  );
                                } else {
                                  return SizedBox(height: 0.0, width: 0.0);
                                }
                              },
                            ),
                          ),
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
                  } else {
                    return Container(
                      height: 300.0,
                      width: 300.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Current member is in the group already!"),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              FlatButton(
                                onPressed: () {
                                  Navigator.pop(context, true);
                                },
                                child: Text(
                                  "Exit",
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  }
                } else {
                  return SetUserIdToMemberDialog(
                      idMember: idMemberSelected, idUser: idUserSelected);
                }

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
  final String idToken;
  final String idUser;

  _ViewModel({
    @required this.idToken,
    @required this.idUser,
  });
}
