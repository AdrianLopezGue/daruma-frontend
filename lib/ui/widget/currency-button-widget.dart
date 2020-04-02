import 'package:daruma/ui/widget/currency-list-widget.dart';
import 'package:daruma/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CurrencyButton extends StatefulWidget {

  final String currentCurrencyCode;  
  final ValueChanged<String> selectedCode;

  CurrencyButton({this.currentCurrencyCode, this.selectedCode});

  @override
  _CurrencyButtonState createState() => _CurrencyButtonState();
}

class _CurrencyButtonState extends State<CurrencyButton> {
  String _currentCode;

  @override
  void initState(){
    _currentCode = widget.currentCurrencyCode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: redPrimaryColor,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              _currentCode,
              style: GoogleFonts.aBeeZee(
                  textStyle: TextStyle(fontSize: 17, color: Colors.white)),
            ),
          ],
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      textColor: white,
      onPressed: () {
        showDialog(
            context: context,
            child: new SimpleDialog(
                title: new Text("Selecciona una divisa"),
                children: <Widget>[
                  CurrenciesList(
                    currentCurrencyCode: _currentCode,
                    selectedCurrency: (currencyCode){
                    setState((){
                      _currentCode = currencyCode;
                    });
                    widget.selectedCode(_currentCode);
                  }),
                ]));
      },
    );
  }
}
