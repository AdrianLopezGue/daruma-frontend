class User{
  String idUser;
  String name;
  String email;

  User({this.idUser, this.name, this.email});

  Map toJson(){
    return{
      'id': this.idUser,
      'name': this.name,
      'email': this.email,
    };
  }
}