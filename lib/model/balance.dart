class Balance {
  String memberId;
  int money;

  Balance(this.memberId, this.money);

  Balance.fromJson(Map<String, dynamic> json) {
    this.memberId = json['_id'];
    this.money = json['money'];
  }
}
