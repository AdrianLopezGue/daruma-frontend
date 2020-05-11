import 'package:daruma/model/group.dart';
import 'package:daruma/model/recurring-bill.dart';
import 'package:daruma/services/bloc/bill.bloc.dart';
import 'package:daruma/services/networking/response.dart';
import 'package:daruma/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecurringBillsList extends StatelessWidget {
  final String tokenId;
  final Group group;

  RecurringBillsList({this.tokenId, this.group});

  Widget build(BuildContext context) {
    final BillBloc _bloc = BillBloc();
    _bloc.getRecurringBills(this.group.groupId, tokenId);

    return StreamBuilder<Response<List<RecurringBill>>>(
        stream: _bloc.billStreamRecurringBills,
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

  Card _buildListTile(RecurringBill recurringBill, Group group, BuildContext context) {

    return Card(
          child: Padding(
            padding: const EdgeInsets.only(left:10.0, right: 10.0),
            child: ListTile(
        contentPadding: const EdgeInsets.only(top: 0.0),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.access_time, size: 35.0),
        ),
        title: Text(recurringBill.billId),
        subtitle: Text("Se cobrará el " + recurringBill.nextCreationDate.toIso8601String().substring(0, 10)),
        onTap: () { },
      ),
          ),
    );
  }
}