class Participant {
  String participantId;
  String name;
  int money;

  Participant({this.participantId, this.name, this.money});

  Map toJson() {
    return {
      'id': this.participantId,
      'money': this.money,
    };
  }

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
        participantId: json['props']['memberId']['props']['value'],
        money: json['props']['amount']['props']['value']);
  }
}
