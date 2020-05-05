import 'package:daruma/model/member.dart';
import 'package:daruma/model/owner.dart';

class Group {
  String groupId;
  String name;
  String currencyCode;
  Owner owner;
  List<Member> members;

  Group({this.groupId, this.name, this.currencyCode, this.owner, this.members});

  Group copyWith(
      {String id,
      String name,
      String currencyCode,
      String ownerId,
      List<Member> members}) {
    return Group(
        groupId: id ?? this.groupId,
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
      '_id': this.groupId,
      'name': this.name,
      'currencyCode': this.currencyCode,
      'owner': owner,
      'members': members
    };
  }

  Group.fromJson(Map<String, dynamic> json) {
    this.groupId = json['_id'];
    this.name = json['name'];
    this.currencyCode = json['currencyCode'];

    Owner owner = new Owner();
    owner.ownerId = json['ownerId'];
    owner.name = '';
    this.owner = owner;
    this.members = [];
  }

  String getMembersAsString() {
    String result = "";
    int index = 0;

    for (int i = 0; i < this.members.length - 1; i++) {
      index += this.members[i].name.length;

      if(index <= 40){
        result += this.members[i].name + ", ";
      }
    }

    index += this.members.last.name.length;


    if(index <= 40){
        result += this.members.last.name;
    }
    else{
      result = result.substring(0, result.length-2);
      result += '...';
    }

    return result;
  }

  String getMemberNameById(String memberId) {
    var selectedMember =
        this.members.singleWhere((member) => member.memberId == memberId);
    return selectedMember.name;
  }

  String getMemberIdByName(String name) {
    var selectedMember =
        this.members.singleWhere((member) => member.name == name);
    return selectedMember.memberId;
  }

  String getUserIdByMemberId(String memberId) {
    var selectedMember =
        this.members.singleWhere((member) => member.memberId == memberId);
    
    if(selectedMember.userId.isEmpty){
      return '';
    }

    return selectedMember.userId;
  }
}
