class Billing {
  final String id;
  final int hoursStayed;
  final int hourRate;
  final int amountOwed;
  final String ownerId;

  Billing._(
      this.id, this.hoursStayed, this.hourRate, this.amountOwed, this.ownerId);

  factory Billing.fromJson(Map json) {
    final id = json['_id'].replaceAll('ObjectId(\"', '').replaceAll('\"', '');
    final hoursStayed = json['hoursStayed'];
    final hourRate = json['hourRate'];
    final amountOwed = json['amountOwed'];
    final ownerId =
        json['ownerId'].replaceAll('ObjectId(\"', '').replaceAll('\"', '');

    return Billing._(id, hoursStayed, hourRate, amountOwed, ownerId);
  }
}
