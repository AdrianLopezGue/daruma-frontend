import 'package:daruma/model/member.dart';
import 'package:daruma/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'members-list.widget.dart';

class PayersButton extends StatefulWidget {
  final int money;
  final String payer;
  final List<Member> members;
  final ValueChanged<String> selectedPayer;

  PayersButton({this.money, this.payer, this.members, this.selectedPayer});

  @override
  _PayersButtonState createState() => _PayersButtonState();
}

class _PayersButtonState extends State<PayersButton> {
  String _currentPayer;

  @override
  void initState() {
    _currentPayer = widget.payer;
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
              _currentPayer,
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
                title: new Text("Elige el pagador"),
                children: <Widget>[
                  MembersList(members: widget.members,
                              selectedMember: (member){
                                setState(() {
                                  _currentPayer = member.name;
                                });                                
                                widget.selectedPayer(member.idMember);
                              })
                ]));
      },
    );
  }
}
