class User {
  String idUser;
  String name;
  String email;

  User({this.idUser, this.name, this.email});

  Map toJson() {
    return {
      'id': this.idUser,
      'name': this.name,
      'email': this.email,
    };
  }

  User.fromJson(Map<String, dynamic> json) {
    this.idUser = json['_id'];
    this.name = json['name'];
    this.email = json['email'];
  }
}
