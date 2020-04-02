import 'package:daruma/util/colors.dart';
import 'package:flutter/material.dart';


class SignOutButton extends StatelessWidget {
  final Function() logout;

  SignOutButton({this.logout});

  Widget build(BuildContext context) {

    return RaisedButton(
      onPressed: () {
        this.logout();
      },
      color: redPrimaryColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Sign Out',
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
      ),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
    );
  }
}
