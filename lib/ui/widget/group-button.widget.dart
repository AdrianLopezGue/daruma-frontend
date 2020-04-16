import 'package:daruma/model/group.dart';
import 'package:daruma/redux/index.dart';
import 'package:daruma/services/dynamic_link/dynamic_links.dart';
import 'package:daruma/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redux/redux.dart';

class GroupButton extends StatelessWidget {
  final String idGroup;
  final String name;

  const GroupButton({
    this.idGroup,
    this.name,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel.fromStore(store),
      builder: (BuildContext context, _ViewModel vm) {
        return _groupButtonView(context, vm);
      },
      onDidChange: (_ViewModel vm) {
        if (vm.loadingError) {
          showDialog(
              context: context,
              child: new SimpleDialog(children: <Widget>[
                Container(
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
                )
              ]));
        }
        if (vm.isLoading) {
          showDialog(
              context: context,
              child: new SimpleDialog(children: <Widget>[
                Center(child: CircularProgressIndicator())
              ]));
        }
      },
    );
  }

  Widget _groupButtonView(BuildContext context, _ViewModel vm) {
    return FlatButton(
      color: redPrimaryColor,
      onPressed: () async {
        vm.load(idGroup, vm.idToken);
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          name,
          style: GoogleFonts.aBeeZee(
              fontSize: 22, textStyle: TextStyle(color: white)),
        ),
      ),
    );
  }

  Future<String> getDynamicLinkForGroup(String groupId) async {
    final AppDynamicLinks _appDynamicLinks = AppDynamicLinks();
    return _appDynamicLinks.createDynamicLink(groupId);
  }
}

class _ViewModel {
  final String idToken;
  final bool isLoading;
  final bool loadingError;
  final Group group;
  final Function(String, String) load;

  _ViewModel({
    this.idToken,
    this.isLoading,
    this.loadingError,
    this.group,
    this.load,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      idToken: store.state.firebaseState.idTokenUser,
      isLoading: store.state.groupState.isLoading,
      loadingError: store.state.groupState.loadingError,
      group: store.state.groupState.group,
      load: (String idGroup, String idToken) {
        store.dispatch(loadGroup(idGroup, idToken));
      },
    );
  }
}
