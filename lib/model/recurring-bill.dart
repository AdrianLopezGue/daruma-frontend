class RecurringBill {
  final String id;
  final String billId;
  final String groupId;
  final DateTime date;
  final int period;

  RecurringBill(
      {this.id,
      this.billId,
      this.groupId,
      this.date,
      this.period});

  Map toJson() {

    return {
      '_id': this.id,
      'billId': this.billId,
      'groupId': this.groupId,
      'date': this.date.toIso8601String(),
      'period': this.period,
    };
  }
}