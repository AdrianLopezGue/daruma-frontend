class Group {
  String id;
  String name;
  String currencyCode;
  String idOwner;

  Group({this.id, this.name, this.currencyCode, this.idOwner});

  Group copyWith({String id, String name, String currencyCode, String idOwner}) {
    return Group(
      id: id ?? this.id,
      name: name ?? this.name,
      currencyCode: currencyCode ?? this.currencyCode,
      idOwner: idOwner ?? this.idOwner,
    );
  }

  Group.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        currencyCode = json['currencyCode'],
        idOwner = json['idOwner'];

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'currencyCode': currencyCode, 'idOwner': idOwner};
}
