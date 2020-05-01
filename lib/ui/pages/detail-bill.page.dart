import 'package:daruma/model/bill.dart';
import 'package:daruma/model/group.dart';
import 'package:daruma/ui/widget/delete-bill-dialog.widget.dart';
import 'package:daruma/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailBillPage extends StatelessWidget {
  final Bill bill;
  final List<String> payers;
  final List<String> debtors;
  final Group group;


  DetailBillPage({this.bill, this.payers, this.debtors, this.group});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: new Text("Detalle del gasto")),
      body: 
          SingleChildScrollView(
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
                          Text(
                            this.payers.toString().substring(1, payers.toString().length-1),
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
                            "Para " + bill.debtors.length.toString() + " participantes",
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
                            this.debtors.toString().substring(1, debtors.toString().length-1),
                            style: GoogleFonts.roboto(
                                fontSize: 14, textStyle: TextStyle(color: black)),
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
                                  child: new SimpleDialog(children: <Widget>[
                                    DeleteBillDialog(billId: this.bill.idBill),
                                  ]));
                            
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
                                      textStyle:
                                          TextStyle(fontSize: 20, color: Colors.white)),
                                ),
                              ],
                            ),
                          ),
                          elevation: 5,
                          shape:
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                    ),
                        ],
                      )
                    ],
                  ),
                ),
            ),
          )
    );
  }
}
