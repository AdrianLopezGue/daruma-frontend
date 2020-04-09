class Owner {
  String idOwner;
  String name;

  Owner({this.idOwner, this.name});

  Map toJson() {
    return {
      'id': this.idOwner,
      'name': this.name,
    };
  }
}