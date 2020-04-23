class Participant {
  String idParticipant;
  String name;
  int money;

  Participant({this.idParticipant, this.name, this.money});

  Map toJson() {
    return {
      'id': this.idParticipant,
      'money': this.money,
    };
  }

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(idParticipant: json['props']['memberId']['props']['value'], money: json['props']['amount']['props']['value']);
  }
}