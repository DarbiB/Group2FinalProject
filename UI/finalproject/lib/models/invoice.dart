class Billing {
  final String id;
  final int hoursStayed;
  final int hourRate;
  final int amountOwed;

  Billing._(this.id, this.hoursStayed, this.hourRate, this.amountOwed);

  factory Billing.fromJson(Map json) {
    final id = json['id'].replaceAll('ObjectId(\"', '').replaceAll('\"', '');
    final hoursStayed = json['hoursStayed'];
    final hourRate = json['hourRate'];
    final amountOwed = json['amountOwed'];

    return Billing._(id, hoursStayed, hourRate, amountOwed);
  }
}
