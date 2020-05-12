import 'package:daruma/model/group.dart';
import 'package:daruma/redux/index.dart';
import 'package:daruma/services/dynamic_link/dynamic_links.dart';
import 'package:daruma/ui/pages/edit-group.page.dart';
import 'package:daruma/ui/pages/group-balance.page.dart';
import 'package:daruma/ui/pages/group-bills.page.dart';
import 'package:daruma/ui/pages/welcome.page.dart';
import 'package:daruma/ui/widget/create-bill-floating-button.widget.dart';
import 'package:daruma/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  @override
  _BottomNavigationBarWidgetState createState() =>
      _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  var currentTab = [
    BillsTabs(),
    GroupBalance(),
  ];

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel(
          group: store.state.groupState.group,
          tokenId: store.state.userState.tokenUserId),
      builder: (BuildContext context, _ViewModel vm) => _groupView(context, vm),
    );
  }

  Widget _groupView(BuildContext context, _ViewModel vm) {
    var provider = Provider.of<BottomNavigationBarProvider>(context);
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: IndexedStack(
          index: provider.currentIndex,
          children: currentTab,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: provider.currentIndex,
          onTap: (index) {
            provider.currentIndex = index;
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.attach_money),
              title: Text('Gastos'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance),
              title: Text('Balances'),
            ),
          ],
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

class BottomNavigationBarProvider with ChangeNotifier {
  int _currentIndex = 0;

  get currentIndex => _currentIndex;

  set currentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
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
