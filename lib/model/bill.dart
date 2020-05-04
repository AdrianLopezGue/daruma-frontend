import 'package:daruma/model/participant.dart';

class Bill {
  String billId;
  String groupId;
  String name;
  DateTime date;
  int money;
  String currencyCode;
  List<Participant> payers;
  List<Participant> debtors;
  String creatorId;

  Bill(
      {this.billId,
      this.groupId,
      this.name,
      this.date,
      this.money,
      this.currencyCode,
      this.payers,
      this.debtors,
      this.creatorId});

  factory Bill.initial() {
    return new Bill(
      billId: '',
      groupId: '',
      name: '',
      date: DateTime.now(),
      money: 0,
      currencyCode: 'EUR',
      payers: [],
      debtors: [],
      creatorId: '',
    );
  }

  Bill copyWith(
      {String billId,
      String groupId,
      String name,
      DateTime date,
      int money,
      String currencyCode,
      List<Participant> payers,
      List<Participant> debtors,
      String creatorId}) {
    return Bill(
        billId: billId ?? this.billId,
        groupId: groupId ?? this.groupId,
        name: name ?? this.name,
        date: date ?? this.date,
        money: money ?? this.money,
        currencyCode: currencyCode ?? this.currencyCode,
        payers: payers ?? this.payers,
        debtors: debtors ?? this.debtors,
        creatorId: creatorId ?? this.creatorId);
  }

  Map toJson() {
    List<Map> payers = this.payers != null
        ? this.payers.map((payer) => payer.toJson()).toList()
        : null;

    List<Participant> finalDebtors =
        this.debtors.where((debtor) => debtor.money != -1).toList();

    List<Map> debtors = finalDebtors != null
        ? finalDebtors.map((debtor) => debtor.toJson()).toList()
        : null;

    var json = {
      'billId': this.billId,
      'groupId': this.groupId,
      'name': this.name,
      'date': this.date.toIso8601String(),
      'money': this.money,
      'currencyCode': this.currencyCode,
      'payers': payers,
      'debtors': debtors,
      'creatorId': this.creatorId,
    };

    return json;
  }

  Bill.fromJson(Map<String, dynamic> json) {
    this.billId = json['_id'];
    this.groupId = json['groupId'];
    this.name = json['name'];
    this.date = DateTime.parse(json['date']);
    this.money = json['money'];
    this.currencyCode = json['currencyCode'];
    this.payers = _parseParticipants(json['payers']);
    this.debtors = _parseParticipants(json['debtors']);
    this.creatorId = json['creatorId'];
  }

  List<Participant> _parseParticipants(List<dynamic> participants) {
    var list = participants;
    List<Participant> billParticipants =
        list.map((participant) => Participant.fromJson(participant)).toList();

    return billParticipants;
  }
}
