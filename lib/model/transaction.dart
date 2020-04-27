import 'package:uuid/uuid.dart';

class Transaction{
  final String sender;
  final String beneficiary;
  final int money;

  Transaction({this.sender, this.beneficiary, this.money});

  Map toJson() {
    var uuid = new Uuid();
    
    return {
      'transactionId': uuid.v4(),
      'senderId': this.sender,
      'beneficiaryId': this.beneficiary,
      'money': this.money,
      'currencyCode': "EUR",
    };
  }
}