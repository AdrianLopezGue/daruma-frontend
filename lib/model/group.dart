
class Group{
  String name;
  String currencyCode;
  String idOwner;

  Group({this.name, this.currencyCode, this.idOwner});

  Group copyWith(
    {String name, 
    String currencyCode,
    String idOwner}
  ){
    return Group(
      name: name  ?? this.name,
      currencyCode: currencyCode ?? this.currencyCode,
      idOwner: idOwner ?? this.idOwner,
    );
  }

  String convertToString(){
    return '{ "name": "$this.name", "currencyCode": "$this.currencyCode", "idOwner": "$this.idOwner"}';   
  }
}