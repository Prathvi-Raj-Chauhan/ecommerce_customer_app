class OrderModelProduct {
  String id;
  String? name;
  String imageUrl;
  int quantity;
  int priceAtPurchase;
  OrderModelProduct({required this.id, required this.imageUrl, this.name, required this.priceAtPurchase, required this.quantity});
  factory OrderModelProduct.fromJson(Map<String, dynamic> json) {
    return OrderModelProduct(
      id: json['product']['_id'],
      imageUrl: json['product']['imageURLs'][0],
      name: json['product']['name'] ?? '',
      quantity: json['quantity'] ?? 0,
      priceAtPurchase: json['priceAtPurchase'] ?? 0
    );
  }
}
