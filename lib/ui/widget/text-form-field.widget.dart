import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final Function validator;
  final Function onSaved;
  final String initialValue;

  CustomTextFormField({
    this.hintText,
    this.validator,
    this.onSaved,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: EdgeInsets.all(15.0),
        filled: true,
        fillColor: Colors.transparent,
      ),
      validator: validator,
      onSaved: onSaved,
      onChanged: onSaved,
      initialValue: initialValue,
    );
  }
}
