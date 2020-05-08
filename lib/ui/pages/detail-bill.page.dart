import 'package:daruma/model/bill.dart';
import 'package:daruma/model/group.dart';
import 'package:daruma/ui/pages/edit-bill.page.dart';
import 'package:daruma/ui/pages/group.page.dart';
import 'package:daruma/ui/widget/delete-bill-dialog.widget.dart';
import 'package:daruma/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailBillPage extends StatelessWidget {
  final Bill bill;
  final Group group;

  DetailBillPage({this.bill, this.group});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text("Detalle del gasto"),
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
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 25.0, top: 15.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          bill.name,
                          style: GoogleFonts.roboto(
                              fontSize: 30, textStyle: TextStyle(color: black)),
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
                          (bill.money / 100).toString() +
                              " " +
                              bill.currencyCode,
                          style: GoogleFonts.roboto(
                              fontSize: 30,
                              textStyle: TextStyle(color: Colors.grey)),
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: black,
                    endIndent: 25.0,
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        "Fecha",
                        style: GoogleFonts.roboto(
                            fontSize: 16,
                            textStyle: TextStyle(color: Colors.grey)),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        bill.date.toIso8601String().substring(0, 10),
                        style: GoogleFonts.roboto(
                            fontSize: 14, textStyle: TextStyle(color: black)),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        "Pagado por",
                        style: GoogleFonts.roboto(
                            fontSize: 16,
                            textStyle: TextStyle(color: Colors.grey)),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: this.bill.payers.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(this.group.getMemberNameById(
                                    this.bill.payers[index].participantId)),
                                trailing: Text(
                                    (this.bill.payers[index].money / 100)
                                            .toString() +
                                        " " +
                                        this.bill.currencyCode),
                              );
                            }),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        "Para ",
                        style: GoogleFonts.roboto(
                            fontSize: 16,
                            textStyle: TextStyle(color: Colors.grey)),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: this.bill.debtors.length,
                            itemBuilder: (context, index) {
                              return ListTile(
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
                  SizedBox(
                    height: 25.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        color: redPrimaryColor,
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (__) {
                                return DeleteBillDialog(
                                    billId: this.bill.billId);
                              });
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
          ),
        ));
  }
}
