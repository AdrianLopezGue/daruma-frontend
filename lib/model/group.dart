import 'package:daruma/model/member.dart';

class Group {
  String idGroup;
  String name;
  String currencyCode;
  String idOwner;
  List<Member> members;

  Group({this.idGroup, this.name, this.currencyCode, this.idOwner, this.members});

  Group copyWith({String id, String name, String currencyCode, String idOwner, List<Member> members}) {
    return Group(
      idGroup: id ?? this.idGroup,
      name: name ?? this.name,
      currencyCode: currencyCode ?? this.currencyCode,
      idOwner: idOwner ?? this.idOwner,
      members: members ?? this.members
    );
  }

  Map toJson(){
    List<Map> members =
        this.members != null ? this.members.map((member) => member.toJson()).toList() : null;

    return {
    'groupId': this.idGroup,
    'name': this.name,
    'currencyCode': this.currencyCode,
    'idOwner': this.idOwner,
    'members': members
    };
  }

  Group.fromJson(Map<String, dynamic> json){
    this.name = json['name'];
    this.currencyCode = json['currencyCode'];
    this.idOwner = json['idOwner'];
  }
}
