class Member{
  String idMember;
  String name;

  Member({this.idMember, this.name});

  Map toJson(){
    return{
      'id': this.idMember,
      'name': this.name,
    };
  }
}