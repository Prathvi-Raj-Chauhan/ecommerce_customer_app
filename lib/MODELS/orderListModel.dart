import 'package:ecommerce_customer/MODELS/address.dart';
import 'package:ecommerce_customer/MODELS/orderProduct.dart';

class OrderListModel {
  String id;
  int totalAmount;
  Address address;
  List<OrderProduct> prods;
  String status;
  DateTime placedAt;
  String? imageUrl;

  OrderListModel({
    required this.address,
    required this.id,
    required this.prods,
    required this.status,
    required this.totalAmount,
    required this.placedAt,
    this.imageUrl
  });

  factory OrderListModel.fromJson(Map<String, dynamic> json) {
    return OrderListModel(
      address: Address.fromJson(json['address']),
      id: json['_id'],
      prods: (json['products'] as List)
          .map((item) => OrderProduct.fromJson(item['product']))
          .toList(),
      status: json['status'],
      totalAmount: json['totalAmount'],
      placedAt: DateTime.parse(json['createdAt']),
      imageUrl: json['products'][0]['product']['imageURLs'][0] ?? "https://dummyjson.com/image/150"
    );
  }
}
