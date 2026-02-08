class Address {
  final String id;
  final String line1;
  final String line2;
  final String city;
  final String state;
  final String postalCode;
  final String country;

  Address({
    required this.id,
    required this.line1,
    required this.line2,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['_id'],
      line1: json['line1'],
      line2: json['line2'] ?? '',
      city: json['city'],
      state: json['state'],
      postalCode: json['postalCode'],
      country: json['country'],
    );
  }
}
