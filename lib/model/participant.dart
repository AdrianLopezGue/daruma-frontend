class Participant {
  String participantId;
  String name;
  int money;

  Participant({this.participantId, this.name, this.money});

  Participant copyWith(
      {String participantId,
      String name,
      String money}) {
    return Participant(
        participantId: participantId ?? this.participantId,
        name: name ?? this.name,
        money: money ?? this.money);
  }

  Map toJson() {
    return {
      '_id': this.participantId,
      'money': this.money,
    };
  }

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
        participantId: json['props']['memberId']['props']['value'],
        money: json['props']['amount']['props']['value']);
  }
}
