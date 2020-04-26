import 'package:daruma/model/group.dart';
import 'package:daruma/redux/index.dart';
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
          idToken: store.state.firebaseState.idTokenUser),
      builder: (BuildContext context, _ViewModel vm) =>
          _balanceView(context, vm),
    );
  }

  Widget _balanceView(BuildContext context, _ViewModel vm) {
    return Scaffold(
        body: ListView(
            children: <Widget>[
            SizedBox(height: 40),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0, left: 25.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          vm.group.name,
                          style: GoogleFonts.aBeeZee(
                              fontSize: 30, textStyle: TextStyle(color: black)),
                        ),
                        BackButton(color: Colors.grey),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            vm.group.getMembersAsString(),
                            style: GoogleFonts.aBeeZee(
                                fontSize: 15,
                                textStyle: TextStyle(color: redPrimaryColor)),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "BALANCES",
                            style: GoogleFonts.aBeeZee(
                                fontSize: 15,
                                textStyle: TextStyle(color: black)),
                          ),
                        ],
                      ),
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
                  ] 
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
