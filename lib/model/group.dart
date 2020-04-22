import 'package:daruma/model/member.dart';
import 'package:daruma/model/owner.dart';

class Group {
  String idGroup;
  String name;
  String currencyCode;
  Owner owner;
  List<Member> members;

  Group(
      {this.idGroup, this.name, this.currencyCode, this.owner, this.members});

  Group copyWith(
      {String id,
      String name,
      String currencyCode,
      String idOwner,
      List<Member> members}) {
    return Group(
        idGroup: id ?? this.idGroup,
        name: name ?? this.name,
        currencyCode: currencyCode ?? this.currencyCode,
        owner: owner ?? this.owner,
        members: members ?? this.members);
  }

  Map toJson() {
    List<Map> members = this.members != null
        ? this.members.map((member) => member.toJson()).toList()
        : null;

    Map owner = this.owner != null ? this.owner.toJson() : null;

    return {
      'groupId': this.idGroup,
      'name': this.name,
      'currencyCode': this.currencyCode,
      'owner': owner,
      'members': members
    };
  }

  Group.fromJson(Map<String, dynamic> json) {
    this.idGroup = json['_id'];
    this.name = json['name'];
    this.currencyCode = json['currencyCode'];

    Owner owner = new Owner();
    owner.idOwner = json['ownerId'];
    owner.name = '';
    this.owner = owner;
    this.members = [];
  }

  String getMembersAsString(){
    String result  = "";
    for(int i = 0; i < this.members.length-1; i++){
      result += this.members[i].name + ", ";
    }

    result += this.members.last.name;

    return result;
  }

  String getMemberNameById(String idMember){
    var selectedMember = this.members.singleWhere((member) => member.idMember == idMember);
    return selectedMember.name;
  }

  String getMemberIdByName(String name){
    var selectedMember = this.members.singleWhere((member) => member.name == name);
    return selectedMember.idMember;
  }
}
