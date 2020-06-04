import 'package:daruma/model/group.dart';
import 'package:daruma/redux/index.dart';
import 'package:daruma/services/dynamic_link/dynamic_links.dart';
import 'package:daruma/ui/pages/edit-group.page.dart';
import 'package:daruma/ui/pages/welcome.page.dart';
import 'package:daruma/ui/widget/balance-list.widget.dart';
import 'package:daruma/ui/widget/create-bill-floating-button.widget.dart';
import 'package:daruma/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share/share.dart';

class GroupBalance extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel(
          group: store.state.groupState.group,
          tokenId: store.state.userState.tokenUserId),
      builder: (BuildContext context, _ViewModel vm) =>
          _balanceView(context, vm),
    );
  }

  Widget _balanceView(BuildContext context, _ViewModel vm) {
    return Scaffold(
        appBar: new AppBar(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(vm.group.name),
                ],
              ),
              SizedBox(
                height: 5.0,
              ),
              Row(
                children: <Widget>[
                  Text(
                    vm.group.getMembersAsString(),
                    style: GoogleFonts.roboto(
                        fontSize: 12, textStyle: TextStyle(color: white)),
                  ),
                ],
              )
            ],
          ),
          leading: BackButton(
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return WelcomeScreen();
                  },
                ),
              );
            },
          ),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: (choice) => handleClick(choice, context, vm.group),
              itemBuilder: (BuildContext context) {
                return {'Compartir', 'Configuración'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 15.0, left: 25.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "Balances",
                          style: GoogleFonts.roboto(
                              fontSize: 24, textStyle: TextStyle(color: black)),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: black,
                    endIndent: 25.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Row(
                      children: <Widget>[
                        BalanceList(tokenId: vm.tokenId, group: vm.group),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: NewBillFloatingButton());
  }

  Future<void> handleClick(
      String value, BuildContext context, Group group) async {
    switch (value) {
      case 'Compartir':
        {
          final RenderBox box = context.findRenderObject();
          final AppDynamicLinks _appDynamicLinks = AppDynamicLinks();
          final String urlLink =
              await _appDynamicLinks.createDynamicLink(group.groupId);
          Share.share(urlLink,
              sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
        }
        break;

      case 'Configuración':
        {
          Navigator.of(context).pop();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return EditGroupPage(group: group);
              },
            ),
          );
        }
        break;
    }
  }
}

class _ViewModel {
  final Group group;
  final String tokenId;

  _ViewModel({
    @required this.group,
    @required this.tokenId,
  });
}
