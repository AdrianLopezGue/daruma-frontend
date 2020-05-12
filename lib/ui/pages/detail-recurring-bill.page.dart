import 'package:daruma/model/bill.dart';
import 'package:daruma/model/group.dart';
import 'package:daruma/model/recurring-bill.dart';
import 'package:daruma/ui/pages/group.page.dart';
import 'package:daruma/ui/widget/delete-recurring-bill-dialog.widget.dart';
import 'package:daruma/ui/widget/detail-bill-app-bar-title.widget.dart';
import 'package:daruma/ui/widget/detail-bill-flexible-app-bar.dart';
import 'package:daruma/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailRecurringBillPage extends StatelessWidget {
  final RecurringBill recurringBill;
  final Bill bill;
  final Group group;

  DetailRecurringBillPage({this.recurringBill, this.bill, this.group});

  @override
  Widget build(BuildContext context) {
    final halfMediaWidth = MediaQuery.of(context).size.width / 1;

    return Scaffold(
        body: CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
            leading: BackButton(
              color: Colors.white,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return GroupPage();
                    },
                  ),
                );
              },
            ),
            title: BillAppBarTitle(title: "Detalle del gasto recurrente"),
            pinned: true,
            expandedHeight: 210.0,
            flexibleSpace: FlexibleSpaceBar(
              background: BillFlexibleAppBar(title: this.bill.name,
                price: (bill.money / 100).toString() + " " + bill.currencyCode,
                bottomLeftSubtitle: "Se cobrará\n" + this.recurringBill.nextCreationDate.toIso8601String().substring(0, 10),
                bottomRightSubtitle:
                    "Fue creado\n" + this.bill.date.toIso8601String().substring(0, 10),),
            )),
        SliverToBoxAdapter(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    color: redPrimaryColor,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          // return object of type Dialog
                          return AlertDialog(
                            content: new Text("¿Seguro que quieres borrar este gasto recurrente?"),
                            actions: <Widget>[
                              new FlatButton(
                                child: new Text("BORRAR"),
                                onPressed: () {
                                  showDialog(
                                  context: context,
                                  builder: (__) {
                                    return DeleteRecurringBillDialog(recurringBillId: this.recurringBill.id);
                                  });
                                },
                              ),
                              new FlatButton(
                                child: new Text("CANCELAR"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      ); 
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(Icons.delete, color: white),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            'Borrar',
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
      ],
    ));
  }
}
