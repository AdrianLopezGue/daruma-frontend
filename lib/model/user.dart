class User {
  String userId;
  String name;
  String email;
  String paypal;

  User({this.userId, this.name, this.email, this.paypal});

  User copyWith({
    String id,
    String name,
    String email,
    String paypal,
  }) {
    return User(
      userId: id ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      paypal: paypal ?? this.paypal,
    );
  }

  Map toJson() {
    return {
      'id': this.userId,
      'name': this.name,
      'email': this.email,
    };
  }

  User.fromJson(Map<String, dynamic> json) {
    this.userId = json['_id'];
    this.name = json['name'];
    this.email = json['email'];
    this.paypal = json['paypal'];
  }
}
