class OrderModel {
  final String id;
  final double totalAmount;
  final DateTime createdAt;
  final DateTime updatedAt;
  String status;

  OrderModel({
    required this.id,
    required this.totalAmount,
    required this.createdAt,
    required this.updatedAt,
    required this.status
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['_id'],
      totalAmount: (json['totalAmount'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      status: json['status']
    );
  }
}
