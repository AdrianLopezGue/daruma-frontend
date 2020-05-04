class Member {
  String idMember;
  String name;
  String idUser;

  Member({this.idMember, this.name, this.idUser});

  Map toJson() {
    return {
      'id': this.idMember,
      'name': this.name,
    };
  }

  Member.fromJson(Map<String, dynamic> json) {
    this.idMember = json['_id'];
    this.name = json['name'];
    this.idUser = json['userId'];
  }
}
