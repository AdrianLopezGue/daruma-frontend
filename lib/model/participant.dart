class Participant {
  String idParticipant;
  int money;

  Participant({this.idParticipant, this.money});

  Map toJson() {
    return {
      'id': this.idParticipant,
      'money': this.money,
    };
  }

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(idParticipant: json['_id'], money: json['money']);
  }
}