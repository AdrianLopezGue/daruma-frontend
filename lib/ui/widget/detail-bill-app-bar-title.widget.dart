import 'package:flutter/material.dart';


class BillAppBarTitle extends StatelessWidget {

  final double barHeight = 66.0;

  const BillAppBarTitle();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(child: Text(
            'Detalle del gasto',
            style: TextStyle(
              color: Colors.white,
                fontFamily: 'Poppins',
                fontSize: 20.0
            ),
          ),),
        ],
      ),
    );
  }
}