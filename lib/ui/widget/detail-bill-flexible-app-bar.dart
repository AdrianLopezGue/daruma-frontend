import 'package:daruma/model/bill.dart';
import 'package:daruma/util/colors.dart';
import 'package:flutter/material.dart';


class BillFlexibleAppBar extends StatelessWidget {

  final Bill bill;

  final double appBarHeight = 66.0;

  const BillFlexibleAppBar({this.bill});

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery
        .of(context)
        .padding
        .top;

    return new Container(
      padding: new EdgeInsets.only(top: statusBarHeight),
      height: statusBarHeight + appBarHeight,
      child: new Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(child: new Text(
                        this.bill.name,
                        style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontSize: 28.0
                        )
                    ),),
                    Container(child: new Text(
                       (bill.money / 100).toString() +
                              " " +
                              bill.currencyCode,
                        style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w800,
                            fontSize: 36.0
                        )
                    ),),
                  ],),),


              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0,left:8.0),
                      child: new Text(
                          this.bill.currencyCode,
                          style: const TextStyle(
                              color: Colors.white70,
                              fontFamily: 'Poppins',
                              fontSize: 16.0
                          )
                      ),
                    ),),

                    Container(child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0,right:8.0),
                      child: Container(
                          child: Row(children: <Widget>[
                            Container(child: Text(
                              this.bill.date.toIso8601String().substring(0, 10), style: const TextStyle(
                                color: Colors.white70,
                                fontFamily: 'Poppins',
                                fontSize: 16.0
                            ),),),
                          ],)

                      ),
                    ),),


                  ],),
              ),
            ],)
      ),
      decoration: new BoxDecoration(
        color: redPrimaryColor,
      ),
    );
  }
}