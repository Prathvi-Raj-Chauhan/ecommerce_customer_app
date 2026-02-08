class DetailedProduct {
  final String id;
  final String name;
  final String brand;
  final String description;
  final int price;
  final int discountedPrice;
  final String weight;
  final String dimensions;
  final double discountPercent;
  final String code;
  final int stockQuantity;
  final List<String> imageURLs;
  final String category;
  final String status;
  DetailedProduct({
    required this.id,
    required this.weight,
    required this.dimensions,
    required this.code,
    required this.name,
    required this.brand,
    required this.description,
    required this.price,
    required this.discountedPrice,
    required this.discountPercent,
    required this.stockQuantity,
    required this.imageURLs,
    required this.category,
    required this.status,
  });

  factory DetailedProduct.fromJson(Map<String, dynamic> json) {
    return DetailedProduct(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      brand: json['brand'] ?? '',
      price: json['price'] ?? 0,
      discountedPrice: json['discountedPrice'] ?? 0,
      discountPercent: (json['discountPercent'] ?? 0).toDouble(),
      status: json['status'] ?? '',
      stockQuantity: json['stockQuantity'] ?? 0,
      description: json['description'] ?? '',
      imageURLs: List<String>.from(json['imageURLs'] ?? []),
      category: json['category'] is Map
          ? json['category']['name'] ?? ''
          : json['category'] ?? '',
      dimensions: json['dimensions'] ?? '',
      code: json['code'] ?? '',
      weight: json['weight'] ?? '',
    );
  }
}
