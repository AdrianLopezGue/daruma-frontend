import 'package:daruma/model/member.dart';
import 'package:flutter/material.dart';

class MembersList extends StatefulWidget {
  final List<Member> members;
  final ValueChanged<Member> selectedMember;

  MembersList({Key key, this.members, this.selectedMember})
      : super(key: key);

  @override
  _MembersListState createState() => _MembersListState();
}

class _MembersListState extends State<MembersList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.0, // Change as per your requirement
      width: 300.0,
      child: ListView.builder(
          itemCount: widget.members.length,
          itemBuilder: (context, index) {
            return ListTile(
                title: Text(widget.members[index].name),
                onTap: () {
                  widget.selectedMember(widget.members[index]);
                  Navigator.pop(context, true);
                });
          }),
    );
  }
}
