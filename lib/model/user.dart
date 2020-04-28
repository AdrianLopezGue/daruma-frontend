class User {
  String idUser;
  String name;
  String email;
  String paypal;

  User({this.idUser, this.name, this.email, this.paypal});

  User copyWith(
      {String id,
      String name,
      String email,
      String paypal,}) {
    return User(
        idUser: id ?? this.idUser,
        name: name ?? this.name,
        email: email ?? this.email,
        paypal: paypal ?? this.paypal,);
  }

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
    this.paypal = json['paypal'];
  }
}
