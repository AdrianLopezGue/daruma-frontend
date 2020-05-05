import 'package:uuid/uuid.dart';

class Transaction {
  final String senderId;
  final String beneficiaryId;
  final int money;
  final String currencyCode;
  final String groupId;

  Transaction(
      {this.senderId,
      this.beneficiaryId,
      this.money,
      this.currencyCode,
      this.groupId});

  Map toJson() {
    var uuid = new Uuid();

    return {
      '_id': uuid.v4(),
      'senderId': this.senderId,
      'beneficiaryId': this.beneficiaryId,
      'money': this.money,
      'currencyCode': this.currencyCode,
      'groupId': this.groupId,
    };
  }
}
