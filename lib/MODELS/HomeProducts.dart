class HomeProducts {
  String id;
  String name;
  int price;
  int discountedPrice;
  double discountPercent;
  int rating;
  String brand;
  String? thumbnail;
  String description;
  HomeProducts({
    required this.id,
    required this.name,
    required this.price,
    required this.discountedPrice,
    required this.discountPercent,
    required this.rating,
    required this.brand,
    required this.description,
    this.thumbnail,
  });
  factory HomeProducts.fromJson(Map<String, dynamic> json) {
    return HomeProducts(
      id: json['_id'] ?? '',
      brand: json['brand'] ?? '',
      description: json['description'] ?? "",
      discountedPrice: json['discountedPrice'],
      discountPercent: (json['discountPercent'] ?? 0).toDouble(),
      name: json['name'],
      price: json['price'],
      thumbnail:
          (json['imageURLs'] != null && (json['imageURLs'] as List).isNotEmpty)
          ? json['imageURLs'][0].toString()
          : null,
      rating: json['rating'] is Map
          ? json['rating']['avg'] ?? 0
          : json['rating'] ?? 0,
    );
  }
}
