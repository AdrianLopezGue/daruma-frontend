import 'package:daruma/model/bill.dart';
import 'package:daruma/model/group.dart';
import 'package:daruma/services/bloc/bill.bloc.dart';
import 'package:daruma/services/networking/response.dart';
import 'package:daruma/ui/pages/detail-bill.page.dart';
import 'package:daruma/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BillsList extends StatelessWidget {
  final String idToken;
  final Group group;

  BillsList({this.idToken, this.group});

  Widget build(BuildContext context) {
    final BillBloc _bloc = BillBloc();
    _bloc.getBills(idToken, this.group.idGroup);

    return StreamBuilder<Response<List<Bill>>>(
        stream: _bloc.billStreamBills,
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
                            padding: const EdgeInsets.all(8.0),                            
                            child: _buildListTile(snapshot.data.data[index], this.group, context),
                          );
                        }));
                break;
              case Status.ERROR:
                return Card(
                  color: redPrimaryColor,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Error recibiendo bills",
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

  ListTile _buildListTile(Bill bill, Group group, BuildContext context) {
    List<String> payers = bill.payers.map((payer) => group.getMemberNameById(payer.idParticipant)).toList();
    List<String> debtors = bill.debtors.map((debtor) => group.getMemberNameById(debtor.idParticipant)).toList();

    return ListTile(
      title: Text(bill.name),
      subtitle: Text("Pagado por " + payers.toString().substring(1, payers.toString().length-1)),
      trailing: Text((bill.money/100).toString() + " " + bill.currencyCode),
      onTap: (){
        Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return DetailBillPage(bill: bill, payers: payers, debtors: debtors, group: group);
              },
            ),
          );
      },
    );
  }
}
