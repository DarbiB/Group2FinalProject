class Owner {
  final String id;
  final String ownerFName;
  final String ownerLName;
  final String ownerAddress;
  final String ownerCity;
  final String ownerState;
  final String ownerZip;
  final String ownerPhone;
  final String ownerEmail;
  final String ownerPet;

  Owner._(
      this.id,
      this.ownerFName,
      this.ownerLName,
      this.ownerAddress,
      this.ownerCity,
      this.ownerState,
      this.ownerZip,
      this.ownerPhone,
      this.ownerEmail,
      this.ownerPet);

  factory Owner.fromJson(Map json) {
    final id = json['id'].replaceAll('ObjectId(\"', '').replaceAll('\"', '');
    final ownerFName = json['ownerFName'];
    final ownerLName = json['ownerLName'];
    final ownerAddress = json['hourRate'];
    final ownerCity = json['ownerCity'];
    final ownerState = json['ownerState'];
    final ownerZip = json['ownerZip'];
    final ownerPhone = json['ownerPhone'];
    final ownerEmail = json['ownerEmail'];
    final ownerPet = json['ownerPet'];

    return Owner._(id, ownerFName, ownerLName, ownerAddress, ownerCity,
        ownerState, ownerZip, ownerPhone, ownerEmail, ownerPet);
  }
}
