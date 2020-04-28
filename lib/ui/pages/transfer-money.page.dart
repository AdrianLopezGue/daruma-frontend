import 'package:daruma/model/group.dart';
import 'package:daruma/model/transaction.dart';
import 'package:daruma/ui/widget/post-transfer-dialog.widget.dart';
import 'package:daruma/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TranferMoneyPage extends StatelessWidget {
  final Transaction transaction;
  final Group group;

  TranferMoneyPage({this.transaction, this.group});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(title: new Text("Liquidar Gasto")),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 25.0, top: 15.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          group.getMemberNameById(transaction.sender) +
                              " pagó a " +
                              group.getMemberNameById(transaction.beneficiary),
                          style: GoogleFonts.roboto(
                              fontSize: 20, textStyle: TextStyle(color: black)),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          (transaction.money / 100).toString() +
                              " " +
                              group.currencyCode,
                          style: GoogleFonts.roboto(
                              fontSize: 30,
                              textStyle: TextStyle(color: Colors.grey)),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        color: redPrimaryColor,
                        onPressed: () {
                          showDialog(
                              context: context,
                              child: new SimpleDialog(children: <Widget>[
                                PostTransferDialog(
                                    transaction: this.transaction),
                              ]));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(Icons.done, color: white),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                'Liquidar',
                                style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                        fontSize: 20, color: Colors.white)),
                              ),
                            ],
                          ),
                        ),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
