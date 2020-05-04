import 'package:daruma/ui/pages/create-bill.page.dart';
import 'package:daruma/util/colors.dart';
import 'package:flutter/material.dart';

class NewBillFloatingButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new FloatingActionButton(
      child: Icon(Icons.add),
      heroTag: null,
      backgroundColor: redPrimaryColor,
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return CreateBillPage();
            },
          ),
        );
      },
    );
  }
}
