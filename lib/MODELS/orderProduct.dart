class OrderProduct {
  String id;
  String? name;
  String imageUrl;
  int quantity;
  int priceAtPurchase;
  OrderProduct({required this.id, required this.imageUrl, this.name, required this.priceAtPurchase, required this.quantity});
  factory OrderProduct.fromJson(Map<String, dynamic> json) {
    return OrderProduct(
      id: json['_id'],
      imageUrl: json['imageURLs'][0],
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? 0,
      priceAtPurchase: json['priceAtPurchase'] ?? 0
    );
  }
}
