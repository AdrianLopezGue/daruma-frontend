import 'package:daruma/model/bill.dart';
import 'package:daruma/model/group.dart';
import 'package:daruma/services/bloc/bill.bloc.dart';
import 'package:daruma/services/networking/response.dart';
import 'package:daruma/ui/pages/detail-bill.page.dart';
import 'package:daruma/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BillsList extends StatelessWidget {
  final String tokenId;
  final Group group;

  BillsList({this.tokenId, this.group});

  Widget build(BuildContext context) {
    final BillBloc _bloc = BillBloc();
    _bloc.getBills(this.group.groupId, tokenId);

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
                          return _buildListTile(
                              snapshot.data.data[index], this.group, context);
                        }));
                break;
              case Status.ERROR:
                return Card(
                  color: redPrimaryColor,
                  child: Text(
                    "Error recibiendo bills",
                    style: GoogleFonts.roboto(
                        fontSize: 22, textStyle: TextStyle(color: white)),
                  ),
                );
                break;
            }
          }
          return Container();
        });
  }

  Card _buildListTile(Bill bill, Group group, BuildContext context) {
    List<String> payers = bill.payers
        .map((payer) => group.getMemberNameById(payer.participantId))
        .toList();

    return Card(
          child: Padding(
            padding: const EdgeInsets.only(left:10.0, right: 10.0),
            child: ListTile(
        contentPadding: const EdgeInsets.only(top: 0.0),
        title: Text(bill.name),
        subtitle: Text("Pagado por " +
              payers.toString().substring(1, payers.toString().length - 1)),
        trailing: Text((bill.money / 100).toString() + " " + bill.currencyCode),
        onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return DetailBillPage(
                      bill: bill, group: group);
                },
              ),
            );
        },
      ),
          ),
    );
  }
}
