class RecurringBill {
  String id;
  String billId;
  String groupId;
  DateTime date;
  int period;
  DateTime nextCreationDate;

  RecurringBill(
      {this.id,
      this.billId,
      this.groupId,
      this.date,
      this.period,
      });

  Map toJson() {

    return {
      '_id': this.id,
      'billId': this.billId,
      'groupId': this.groupId,
      'date': this.date.toIso8601String(),
      'period': this.period,
    };
  }

  RecurringBill.fromJson(Map<String, dynamic> json) {
    this.id = json['_id'];
    this.billId = json['billId'];
    this.groupId = json['groupId'];
    this.nextCreationDate = DateTime.parse(json['nextCreationDate']);
  }
}