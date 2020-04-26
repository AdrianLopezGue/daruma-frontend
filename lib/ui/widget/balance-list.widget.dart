import 'package:daruma/model/group.dart';
import 'package:daruma/model/transaction.dart';
import 'package:daruma/services/bloc/balance.bloc.dart';
import 'package:daruma/services/networking/response.dart';
import 'package:daruma/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BalanceList extends StatelessWidget {
  final String idToken;
  final Group group;

  BalanceList({this.idToken, this.group});

  Widget build(BuildContext context) {
    final BalanceBloc _bloc = BalanceBloc();
    _bloc.getBalance(idToken, this.group.idGroup);

    return StreamBuilder<Response<List<Transaction>>>(
        stream: _bloc.balanceStream,
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
                    child: ListView.builder(
                        itemCount: snapshot.data.data.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),                            
                            child: _buildListTile(snapshot.data.data[index], group, context),
                          );
                        }));
                break;
              case Status.ERROR:
                return Card(
                  color: redPrimaryColor,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Error recibiendo transactions",
                      style: GoogleFonts.aBeeZee(
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

  ListTile _buildListTile(Transaction transaction, Group group, BuildContext context) {

    return ListTile(
      title: Text(group.getMemberNameById(transaction.sender) + " debe a " + group.getMemberNameById(transaction.beneficiary)),
      trailing: Text((transaction.money/100).toString()),
    );
  }
}