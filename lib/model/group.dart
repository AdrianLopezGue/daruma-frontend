
class Group{
  String name;
  String currencyCode;

  Group({this.name, this.currencyCode});

  Group copyWith(
    {String name, 
    String currencyCode}
  ){
    return Group(
      name: name  ?? this.name,
      currencyCode: currencyCode ?? this.currencyCode
    );
  }
}