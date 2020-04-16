import 'package:daruma/util/colors.dart';
import 'package:flutter/material.dart';

class OAuthLoginButton extends StatelessWidget {
  final Function() onPressed;
  final String text;
  final String assetName;
  final Color backgroundColor;

  OAuthLoginButton(
      {this.onPressed, this.text, this.assetName, this.backgroundColor});

  Widget build(BuildContext context) {
    return OutlineButton(
      splashColor: backgroundColor,
      onPressed: onPressed,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: white),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage(assetName), height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 20,
                  color: white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
