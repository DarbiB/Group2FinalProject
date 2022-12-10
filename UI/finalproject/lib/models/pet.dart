class Pet {
  final String id;
  final String petName;

  Pet._(this.id, this.petName);

  factory Pet.fromJson(Map json) {
    final id = json['id'].replaceAll('ObjectId(\"', '').replaceAll('\"', '');
    final petName = json['petName'];

    return Pet._(id, petName);
  }
}
