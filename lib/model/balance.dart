class Balance {
  String idMember;
  int money;

  Balance(this.idMember, this.money);

  Balance.fromJson(Map<String, dynamic> json) {
    this.idMember = json['_id'];
    this.money = json['money'];
  }
}
