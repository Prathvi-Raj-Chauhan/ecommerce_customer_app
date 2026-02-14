import 'dart:math';

import 'package:ecommerce_customer/COMPONENTS/AuthDialog.dart';
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

  bool? isLoggedin; // Changed to nullable

  Future<void> checkAuthAndSetState() async {
    try {
      var res = await Dioclient.dio.get('/auth-check');
      setState(() {
        if (res.statusCode == 401) {
          isLoggedin = false;
        } else {
          isLoggedin = res.data['status'] == true;
        }
      });
    } catch (e) {
      setState(() {
        isLoggedin = false;
      });
    }
  }

  Future<void> getOrderHistory() async {
    try {
      var re = await Dioclient.dio.get('/orderHistory');
      final res = re.data;
      final List ord = res['orders'];
      final fetched = ord.map((item) => OrderListModel.fromJson(item)).toList();
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
    checkAuthAndSetState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:  isLoggedin == null
          ? const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            )
          : !isLoggedin!
              ? pleaseLogin()
              : Scaffold(
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
      ),
    );
  }

  Widget orderList() {
    return orders.length != 0
        ? Expanded(
            child: Container(
              margin: EdgeInsets.all(15),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: orders.length,

                itemBuilder: (context, index) {
                  return orderTile(orders[index]);
                },
              ),
            ),
          )
        : Container(
            height: 500,
            child: Center(child: Text('You Have Not placed any Order yet 👜')),
          );
  }

  Widget orderTile(OrderListModel order) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: InkWell(
        onTap: () {
          context.push('/order/${order.id}');
        },
        child: Container(
          margin: EdgeInsets.all(2),
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
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
                      Container(
                        height: 50,
                        width: 50,
                        child: ClipRRect(
                          child: Image.network(
                            "${order.imageUrl}",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
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
      Widget pleaseLogin() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min, // 👈 important
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: Container(child: Text('Please Login First'))),
          loginButton(),
        ],
      ),
    );
  }

  Widget loginButton() {
    return ElevatedButton(
      onPressed: () async {
        await showDialog<bool>(
          context: context,
          builder: (context) {
            return AuthDialog(context: context, wantsLogin: true);
          },
        );
        context.go('/');
      },
      child: Text(
        'Login Now !',
        style: GoogleFonts.nunito(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(backgroundColor: CustomerTheme.accent),
    );
  }
}
