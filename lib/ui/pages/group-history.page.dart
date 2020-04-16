import 'package:flutter/material.dart';

class GroupHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daruma'),
      ),
      body: DefaultTextStyle(
        style: TextStyle(
            inherit: true,
            fontSize: 14.0,
            fontWeight: FontWeight.normal,
            fontFamily: 'Montserrat',
            decoration: TextDecoration.none,
            decorationColor: Colors.black,
            decorationStyle: TextDecorationStyle.solid,
            color: Colors.black),
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Historial',
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
