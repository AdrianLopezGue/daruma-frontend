import 'package:daruma/model/bill.dart';
import 'package:daruma/model/group.dart';
import 'package:daruma/ui/pages/edit-bill.page.dart';
import 'package:daruma/ui/pages/group.page.dart';
import 'package:daruma/ui/widget/delete-bill-dialog.widget.dart';
import 'package:daruma/ui/widget/detail-bill-app-bar-title.widget.dart';
import 'package:daruma/ui/widget/detail-bill-flexible-app-bar.dart';
import 'package:daruma/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailBillPage extends StatelessWidget {
  final Bill bill;
  final Group group;

  DetailBillPage({this.bill, this.group});

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
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return EditBillPage(bill: this.bill);
                      },
                    ),
                  );
                },
              )
            ],
            title: MyAppBar(),
            pinned: true,
            expandedHeight: 210.0,
            flexibleSpace: FlexibleSpaceBar(
              background: MyFlexiableAppBar(bill: this.bill),
            )),
        SliverToBoxAdapter(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    alignment: Alignment.topCenter,
                    width: halfMediaWidth,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  "Pagado por", style: GoogleFonts.roboto(fontSize: 16, textStyle: TextStyle(color: Colors.grey))
                                )
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: ListView.builder(
                                    padding: EdgeInsets.all(0.0),
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: this.bill.payers.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          contentPadding: EdgeInsets.all(0.0),
                                          title: Text(this
                                              .group
                                              .getMemberNameById(this
                                                  .bill
                                                  .payers[index]
                                                  .participantId)),
                                          trailing: Text(
                                              (this.bill.payers[index].money /
                                                          100)
                                                      .toString() +
                                                  " " +
                                                  this.bill.currencyCode),
                                        );
                                      }),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                    alignment: Alignment.topCenter,
                    width: halfMediaWidth,
                    child: Card(
                        child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  "Para ",
                                  style: GoogleFonts.roboto(
                                      fontSize: 16, textStyle: TextStyle(color: Colors.grey)),
                                )
                              ],
                            ),
                            Row(
                          children: <Widget>[
                            Expanded(
                              child: ListView.builder(
                                  padding: EdgeInsets.all(0.0),
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: this.bill.debtors.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      contentPadding: EdgeInsets.all(0.0),
                                      title: Text(this.group.getMemberNameById(
                                          this.bill.debtors[index].participantId)),
                                      trailing: Text(
                                          (this.bill.debtors[index].money / 100)
                                                  .toString() +
                                              " " +
                                              this.bill.currencyCode),
                                    );
                                  }),
                            )
                          ],
                        ),
                          ],
                        ),
                      ),
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
                        builder: (BuildContext context) {
                          // return object of type Dialog
                          return AlertDialog(
                            content: new Text("¿Seguro que quieres borrar el gasto?"),
                            actions: <Widget>[
                              new FlatButton(
                                child: new Text("BORRAR"),
                                onPressed: () {
                                  showDialog(
                                  context: context,
                                  builder: (__) {
                                    return DeleteBillDialog(billId: this.bill.billId);
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
