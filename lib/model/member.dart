class Member {
  String memberId;
  String name;
  String userId;

  Member({this.memberId, this.name, this.userId});

  Map toJson() {
    return {
      '_id': this.memberId,
      'name': this.name,
    };
  }

  Member.fromJson(Map<String, dynamic> json) {
    this.memberId = json['_id'];
    this.name = json['name'];
    this.userId = json['userId'];
  }
}
