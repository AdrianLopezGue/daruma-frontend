class Owner {
  String ownerId;
  String name;

  Owner({this.ownerId, this.name});

  Map toJson() {
    return {
      'id': this.ownerId,
      'name': this.name,
    };
  }
}
