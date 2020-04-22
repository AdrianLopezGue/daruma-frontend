import 'package:daruma/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/formatters/money_input_formatter.dart';

class CustomNumberFormField extends StatelessWidget {
  final String hintText;
  final FormFieldSetter<String> validator;
  final FormFieldSetter<String> onChanged;

  CustomNumberFormField({
    this.hintText,
    this.validator,
    this.onChanged
  });

  @override
  Widget build(BuildContext context) {
    
    return TextFormField(
        decoration: InputDecoration(
        hintText: hintText,
        contentPadding: EdgeInsets.all(15.0),
        filled: true,
        fillColor: white,
      ),
      validator: validator,
      onChanged: onChanged,
      inputFormatters: [
        MoneyInputFormatter(),
        BlacklistingTextInputFormatter(new RegExp('-')),        
      ],
      keyboardType: TextInputType.number,
    );
  }
}