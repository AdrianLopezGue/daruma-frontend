import 'package:daruma/model/participant.dart';

class Bill {
  String idBill;
  String idGroup;
  String name;
  DateTime date;
  int money;
  String currencyCode;
  List<Participant> payers;
  List<Participant> debtors;
  String idCreator;

  Bill(
      {this.idBill,
      this.idGroup,
      this.name,
      this.date,
      this.money,
      this.currencyCode,
      this.payers,
      this.debtors,
      this.idCreator});

  Bill copyWith(
      {String idBill,
      String idGroup,
      String name,
      DateTime date,
      int money,
      String currencyCode,
      List<Participant> payers,
      List<Participant> debtors,
      String idCreator      
      }) {
    return Bill(
        idBill: idBill ?? this.idBill,
        idGroup: idGroup ?? this.idGroup,
        name: name ?? this.name,
        date: date ?? this.date,
        money: money ?? this.money,
        currencyCode: currencyCode ?? this.currencyCode,
        payers: payers ?? this.payers,
        debtors: debtors ?? this.debtors,
        idCreator: idCreator ?? this.idCreator        
        );
  }

  Map toJson() {
    List<Map> payers = this.payers != null
        ? this.payers.map((payer) => payer.toJson()).toList()
        : null;

    List<Map> debtors = this.debtors != null
        ? this.debtors.map((debtor) => debtor.toJson()).toList()
        : null;

    return {
      'billId': this.idBill,
      'groupId': this.idGroup,
      'name': this.name,
      'date': this.date,
      'money': this.money,
      'currencyCode': this.currencyCode,
      'payers': payers,
      'debtors': debtors,
      'creatorId': this.idCreator,
    };
  }

  Bill.fromJson(Map<String, dynamic> json) {
    this.idBill = json['_id'];
    this.idGroup = json['groupId'];
    this.name = json['name'];
    this.date = json['date'];
    this.money = json['money'];
    this.currencyCode = json['currencyCode'];
    this.payers = _parseParticipants(json['payers']);
    this.payers = _parseParticipants(json['debtors']);
    this.idCreator = json['creatorId'];
  }

  List<Participant> _parseParticipants(Map<String, dynamic> participants){

    var list = participants as List;
    List<Participant> billParticipants = list.map((participant) => Participant.fromJson(participant)).toList();
    
    return billParticipants;
  }
}
