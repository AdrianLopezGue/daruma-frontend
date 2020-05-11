import 'package:daruma/model/member.dart';
import 'package:daruma/redux/state.dart';
import 'package:daruma/services/bloc/member.bloc.dart';
import 'package:daruma/services/networking/index.dart';
import 'package:daruma/ui/widget/set-userid-to-member-dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class SelectMemberInGroupDialog extends StatefulWidget {
  final String groupId;

  SelectMemberInGroupDialog({this.groupId});

  @override
  _SelectMemberInGroupDialogState createState() =>
      _SelectMemberInGroupDialogState();
}

class _SelectMemberInGroupDialogState extends State<SelectMemberInGroupDialog> {
  bool memberSelected = false;
  String memberIdSelected = '';
  String userIdSelected = '';

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(converter: (store) {
      return new _ViewModel(
        tokenId: store.state.userState.tokenUserId,
        userId: store.state.userState.user.userId,
      );
    }, builder: (BuildContext context, _ViewModel vm) {
      return _selectMemberInGroupDialogView(context, vm);
    });
  }

  Widget _selectMemberInGroupDialogView(BuildContext context, _ViewModel vm) {
    final MemberBloc _bloc = MemberBloc();

    _bloc.getMembers(this.widget.groupId, vm.tokenId);

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
                      .where((member) => member.userId == vm.userId);

                  if (memberInGroup.isEmpty) {
                    return Container(
                      height: 300.0,
                      width: 300.0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Expanded(
                            child: ListView.builder(
                              itemCount: snapshot.data.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                if (snapshot.data.data[index].userId.isEmpty) {
                                  return ListTile(
                                    leading: Icon(Icons.account_circle),
                                    title: Text(snapshot.data.data[index].name),
                                    onTap: () {
                                      setState(() {
                                        memberSelected = true;
                                        memberIdSelected =
                                            snapshot.data.data[index].memberId;
                                        userIdSelected = vm.userId;
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
                              "Cancelar",
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
                              Text("El miembro ya se encuentra en el grupo"),
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
                      memberId: memberIdSelected, userId: userIdSelected);
                }

                break;
              case Status.ERROR:
                return Container(
                  height: 300.0, // Change as per your requirement
                  width: 300.0,
                  child: Row(
                    children: <Widget>[
                      Text("Se ha producido un error trayendo los miebros del grupo"),
                      FlatButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child: Text(
                          "Salir",
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
  final String tokenId;
  final String userId;

  _ViewModel({
    @required this.tokenId,
    @required this.userId,
  });
}
