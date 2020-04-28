import 'package:daruma/model/group.dart';
import 'package:daruma/redux/index.dart';
import 'package:daruma/ui/pages/welcome.page.dart';
import 'package:daruma/ui/widget/balance-list.widget.dart';
import 'package:daruma/ui/widget/create-bill-floating-button.widget.dart';
import 'package:daruma/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';

class GroupBalance extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel(
          group: store.state.groupState.group,
          idToken: store.state.userState.idTokenUser),
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
              SizedBox(height: 5.0,),
              Row(
                children: <Widget>[
                  Text(vm.group.getMembersAsString(), style: GoogleFonts.roboto(
                                fontSize: 12, textStyle: TextStyle(color: white)),),
                ],
              )
            ],
          ),
          leading: BackButton(color: Colors.white, onPressed: (){
            Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return WelcomeScreen();
              },
            ),
          );
          },),
          ),
        body: SingleChildScrollView(
            child:
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0, left: 25.0),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "BALANCES",
                            style: GoogleFonts.roboto(
                                fontSize: 24,
                                textStyle: TextStyle(color: black)),
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
                          BalanceList(
                              idToken: vm.idToken, group: vm.group),
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
}

class _ViewModel {
  final Group group;
  final String idToken;

  _ViewModel({
    @required this.group,
    @required this.idToken,
  });
}
