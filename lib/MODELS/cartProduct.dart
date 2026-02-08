import 'package:ecommerce_customer/MODELS/DetailedProduct.dart';

class CartProduct {
  final DetailedProduct product;
  final int quantity;

  CartProduct({
    required this.product,
    required this.quantity,
  });

  factory CartProduct.fromJson(Map<String, dynamic> json) {
    return CartProduct(
      product: DetailedProduct.fromJson(json['productId']),
      quantity: json['quantity'],
    );
  }
}
