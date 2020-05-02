import 'package:daruma/model/group.dart';
import 'package:daruma/model/member.dart';
import 'package:daruma/redux/index.dart';
import 'package:daruma/ui/widget/delete-member-dialog.widget.dart';
import 'package:daruma/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class MembersList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(converter: (store) {
      return new _ViewModel(
        idToken: store.state.userState.idTokenUser,
        group: store.state.groupState.group,
      );
    }, builder: (BuildContext context, _ViewModel vm) {
      return _membersListView(context, vm);
    });
  }

  Widget _membersListView(BuildContext context, _ViewModel vm) {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: vm.group.members.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(3.0),
              child: _buildListTile(vm.group.members[index], context),
            );
          }),
    ));
  }

  ListTile _buildListTile(Member member, BuildContext context) {
    return ListTile(
      title: Text(member.name),
      trailing: IconButton(
        icon: Icon(
          Icons.clear,
          color: black,
        ),
        onPressed: () {
          showDialog(
          context: context,
          child:
              new SimpleDialog(children: <Widget>[
            DeleteMemberDialog(
                member: member),
          ]));
        },
      ),
    );
  }
}

class _ViewModel {
  final String idToken;
  final Group group;

  _ViewModel({
    @required this.idToken,
    @required this.group,
  });
}
