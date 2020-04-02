class Group {
  String idGroup;
  String name;
  String currencyCode;
  String idOwner;

  Group({this.idGroup, this.name, this.currencyCode, this.idOwner});

  Group copyWith({String id, String name, String currencyCode, String idOwner}) {
    return Group(
      idGroup: id ?? this.idGroup,
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
      {'id': idGroup, 'name': name, 'currencyCode': currencyCode, 'idOwner': idOwner};
}
