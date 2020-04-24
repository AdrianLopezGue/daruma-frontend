import 'package:daruma/util/colors.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final Function validator;
  final Function onSaved;

  CustomTextFormField({
    this.hintText,
    this.validator,
    this.onSaved,
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
      onSaved: onSaved,
      onChanged: onSaved,
    );
  }
}