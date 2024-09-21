class Brewery {
  final String name;
  final String breweryType;
  final String address;
  final String country;
  final String city;
  final String state;

  Brewery({
    required this.name,
    required this.breweryType,
    required this.address,
    required this.country,
    required this.city,
    required this.state,
  });

  factory Brewery.fromJson(Map<String, dynamic> json) {
    return Brewery(
      name: json['name'] ?? '',
      breweryType: json['brewery_type'] ?? '',
      address: json['address_1'] ?? '',
      country: json['country'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
    );
  }
}
