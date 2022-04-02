class Contact {
  int? id;
  late String fullName;
  late String phoneNumber;

  Contact({this.id, required this.fullName, required this.phoneNumber});

  Map<String,dynamic> toMap() {
    return {
      'id' : id,
      'fullName' : fullName,
      'phoneNumber' : phoneNumber
    };
  }
}