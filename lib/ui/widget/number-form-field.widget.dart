import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/formatters/money_input_formatter.dart';

class CustomNumberFormField extends StatelessWidget {
  final String hintText;
  final String initialValue;
  final FormFieldSetter<String> validator;
  final FormFieldSetter<String> onChanged;

  CustomNumberFormField({this.hintText, this.initialValue, this.validator, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: EdgeInsets.all(1.0),
        filled: true,
        fillColor: Colors.transparent,
        
      ),
      validator: validator,
      onChanged: onChanged,
      initialValue: initialValue,
      inputFormatters: [
        MoneyInputFormatter(),
        BlacklistingTextInputFormatter(new RegExp('-')),
      ],
      keyboardType: TextInputType.number,
    );
  }
}
