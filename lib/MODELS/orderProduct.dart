class OrderProduct {
  String id;
  String? name;
  String imageUrl;
  int quantity;
  int priceAtPurchase;
  OrderProduct({required this.id, required this.imageUrl, this.name, required this.priceAtPurchase, required this.quantity});
  factory OrderProduct.fromJson(Map<String, dynamic> json) {
    // Handle empty imageURLs array
    String imgUrl = '';
    if (json['imageURLs'] != null && (json['imageURLs'] as List).isNotEmpty) {
      imgUrl = json['imageURLs'][0];
    }
    
    return OrderProduct(
      id: json['_id'],
      imageUrl: imgUrl,
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? 0,
      priceAtPurchase: json['priceAtPurchase'] ?? 0
    );
  }
}