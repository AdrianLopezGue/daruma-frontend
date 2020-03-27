class Group {
  String name;
  String currencyCode;
  String idOwner;

  Group({this.name, this.currencyCode, this.idOwner});

  Group copyWith({String name, String currencyCode, String idOwner}) {
    return Group(
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
      {'name': name, 'currencyCode': currencyCode, 'idOwner': idOwner};
}
