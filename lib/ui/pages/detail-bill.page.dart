import 'package:daruma/model/bill.dart';
import 'package:daruma/model/group.dart';
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
      body: 
          SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 25.0, top: 15.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        BackButton(color: Colors.grey),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            bill.name,
                            style: GoogleFonts.aBeeZee(
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
                            style: GoogleFonts.aBeeZee(
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
                          style: GoogleFonts.aBeeZee(
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
                          style: GoogleFonts.aBeeZee(
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
                          style: GoogleFonts.aBeeZee(
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
                          style: GoogleFonts.aBeeZee(
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
                          style: GoogleFonts.aBeeZee(
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
                          style: GoogleFonts.aBeeZee(
                              fontSize: 14, textStyle: TextStyle(color: black)),
                        )
                      ],
                    )
                  ],
                ),
              ),
          )
    );
  }
}
