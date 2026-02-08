import 'dart:math';

import 'package:ecommerce_customer/MODELS/orderListModel.dart';
import 'package:ecommerce_customer/SERVICES/dioclient.dart';
import 'package:ecommerce_customer/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class YourOrders extends StatefulWidget {
  const YourOrders({super.key});

  @override
  State<YourOrders> createState() => _YourOrdersState();
}

class _YourOrdersState extends State<YourOrders> {
  Color statusColor(String str) {
    if (str == "Pending") {
      return const Color.fromARGB(255, 186, 176, 85);
    } else if (str == "Cancelled") {
      return Colors.red;
    } else if (str == "Packed") {
      return const Color.fromARGB(255, 18, 135, 0);
    } else if (str == "Shipped") {
      return Colors.blue;
    } else if (str == "Delivered") {
      return Colors.green;
    } else {
      return Colors.greenAccent;
    }
  }

  Future<void> getOrderHistory() async {
    try {
      var re = await Dioclient.dio.get('/orderHistory');
      final res = re.data;
      final List ord = res['orders'];
      final fetched = ord.map((item) => OrderListModel.fromJson(item));
      setState(() {
        orders.clear();
        orders.addAll(fetched);
      });
    } catch (e) {
      print(' Got in catch ${e}');
    }
  }

  List<OrderListModel> orders = [];
  @override
  void initState() {
    super.initState();
    getOrderHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 10),
          Center(
            child: Text(
              'Your Orders',
              style: GoogleFonts.nunito(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
          orderList(),
        ],
      ),
    );
  }

  Widget orderList() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(15),
        child: ListView.builder(
          shrinkWrap: true,

          itemBuilder: (context, index) {
            return orderTile(orders[index]);
          },

          itemCount: orders.length,
        ),
      ),
    );
  }

  Widget orderTile(OrderListModel order) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: InkWell(
        onTap: () {
          context.go('/order/${order.id}');
        },
        child: Container(
          margin: EdgeInsets.all(2),
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: BoxBorder.all(color: Colors.grey.shade300, width: 1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order ${order.status}',
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.bold,
                      color: statusColor(order.status),
                    ),
                  ),
                  Text(
                    'Placed at - ${order.placedAt}',
                    style: GoogleFonts.nunito(color: Colors.grey, fontSize: 12),
                  ),
                  Row(
                    children: [
                      Icon(Icons.image, size: 35),
                      const SizedBox(width: 5),
                      Icon(Icons.image, size: 35),
                      const SizedBox(width: 5),
                      Icon(Icons.image, size: 35),
                    ],
                  ),
                ],
              ),
              Text(
                '₹${order.totalAmount}',
                style: GoogleFonts.nunito(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
  // Widget orderTile(OrderListModel order) {
  //   return ListTile(
  //     isThreeLine: true,
  //     title: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           'Order ${order.status}',
  //           style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
  //         ),
  //         Text(
  //           'Placed at - ${order.placedAt}',
  //           style: GoogleFonts.nunito(color: Colors.grey, fontSize: 12),
  //         ),
  //       ],
  //     ),

  //     subtitle: Row(
  //       children: [
  //         Icon(Icons.image, size: 35),
  //         const SizedBox(width: 5),
  //         Icon(Icons.image, size: 35),
  //         const SizedBox(width: 5),
  //         Icon(Icons.image, size: 35),
  //       ],
  //     ),
  //     trailing: Text(
  //       '₹${order.totalAmount}',
  //       style: GoogleFonts.nunito(fontSize: 18),
  //     ),
  //   );
  // }
}
