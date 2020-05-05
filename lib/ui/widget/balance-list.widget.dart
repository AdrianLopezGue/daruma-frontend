import 'package:daruma/model/group.dart';
import 'package:daruma/model/transaction.dart';
import 'package:daruma/services/bloc/balance.bloc.dart';
import 'package:daruma/services/networking/response.dart';
import 'package:daruma/ui/pages/transfer-money.page.dart';
import 'package:daruma/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BalanceList extends StatelessWidget {
  final String tokenId;
  final Group group;

  BalanceList({this.tokenId, this.group});

  Widget build(BuildContext context) {
    final BalanceBloc _bloc = new BalanceBloc();
    _bloc.getBalance(tokenId, this.group);

    return StreamBuilder<Response<List<Transaction>>>(
        stream: _bloc.balanceStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.LOADING:
                return Center(child: CircularProgressIndicator());
                break;

              case Status.COMPLETED:
                return Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data.data.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, bottom: 8.0, right: 25.0),
                          child: Column(
                            children: <Widget>[
                              _buildListTile(
                                  snapshot.data.data[index], group, context),
                            ],
                          ),
                        );
                      }),
                );
                break;
              case Status.ERROR:
                return Card(
                  color: redPrimaryColor,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Error recibiendo transactions",
                      style: GoogleFonts.roboto(
                          fontSize: 22, textStyle: TextStyle(color: white)),
                    ),
                  ),
                );
                break;
            }
          }
          return Container();
        });
  }

  Container _buildListTile(
      Transaction transaction, Group group, BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    group.getMemberNameById(transaction.senderId) +
                        " debe a " +
                        group.getMemberNameById(transaction.beneficiaryId),
                    style: GoogleFonts.roboto(
                        textStyle: TextStyle(fontSize: 14, color: black)),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  FlatButton(
                      child: Text("Liquidar",
                      style: GoogleFonts.roboto(
                          fontSize: 16, textStyle: TextStyle(color: Colors.green))),
                      textColor: Colors.green,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return TranferMoneyPage(
                                  transaction: transaction, group: group);
                            },
                          ),
                        );
                      },
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.grey)))
                ],
              )
            ],
          ),
        ),
        trailing: Text(
            (transaction.money / 100).toString() + " " + group.currencyCode, style: GoogleFonts.roboto(
                        textStyle: TextStyle(fontSize: 14, color: black))),
      ),
    );
  }
}
