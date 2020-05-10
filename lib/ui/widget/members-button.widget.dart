import 'package:daruma/model/member.dart';
import 'package:daruma/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_buttons/grouped_buttons.dart';

class MembersButton extends StatefulWidget {
  final List<Member> members;
  final ValueChanged<List<String>> selectedMembers;

  MembersButton({this.members, this.selectedMembers});

  @override
  _MembersButtonState createState() => _MembersButtonState();
}

class _MembersButtonState extends State<MembersButton> {
  List<String> membersNames = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: redPrimaryColor,
      child: Text(
        membersNames.isEmpty
            ? widget.members.first.name
            : (membersNames.length.toString() + "+ PERSONAS"),
        style: GoogleFonts.roboto(
            textStyle: TextStyle(fontSize: 15, color: Colors.white)),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      textColor: white,
      onPressed: () {
        showDialog(
          context: context,
          child: new SimpleDialog(
            title: new Text("Elige el pagador"),
            children: <Widget>[
              CheckboxGroup(
                labels: widget.members.map((member) => member.name).toList(),
                onSelected: (List<String> checked) => membersNames = checked,
                activeColor: redPrimaryColor,
              ),
              FlatButton(
                  onPressed: () {
                    widget.selectedMembers(membersNames);
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  child: Text("Guardar"))
            ],
          ),
        );
      },
    );
  }
}
