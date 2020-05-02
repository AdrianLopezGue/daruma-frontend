import 'package:daruma/model/member.dart';
import 'package:daruma/redux/index.dart';
import 'package:daruma/redux/state.dart';
import 'package:daruma/services/bloc/member.bloc.dart';
import 'package:daruma/services/networking/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class AddMemberDialog extends StatelessWidget {

  final Member member;
  final String groupId;

  AddMemberDialog({this.member, this.groupId});

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(converter: (store) {
      return new _ViewModel(
        idToken: store.state.userState.idTokenUser,
        addMember: (Member newMember) {
          store.dispatch(AddMemberToGroupAction(newMember));
        }
      );
    }, builder: (BuildContext context, _ViewModel vm) {
      return _addMemberDialogView(context, vm);
    });
  }

  Widget _addMemberDialogView(BuildContext context, _ViewModel vm) {
    final MemberBloc _bloc = MemberBloc();

    _bloc.addMember(
        this.member,
        this.groupId,
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
                      Text("Add Member completed!"),
                      FlatButton(
                        onPressed: () {
                          vm.addMember(this.member);                         
                          Navigator.of(context).pop();
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
                      Text("Add Member ERROR!"),
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
  final Function(Member) addMember;

  _ViewModel({
    @required this.idToken,
    @required this.addMember,
  });
}