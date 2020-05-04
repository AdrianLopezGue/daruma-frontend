import 'package:uuid/uuid.dart';

class Transaction {
  final String sender;
  final String beneficiary;
  final int money;
  final String currencyCode;
  final String idGroup;

  Transaction(
      {this.sender,
      this.beneficiary,
      this.money,
      this.currencyCode,
      this.idGroup});

  Map toJson() {
    var uuid = new Uuid();

    return {
      'transactionId': uuid.v4(),
      'senderId': this.sender,
      'beneficiaryId': this.beneficiary,
      'money': this.money,
      'currencyCode': this.currencyCode,
      'idGroup': this.idGroup,
    };
  }
}
