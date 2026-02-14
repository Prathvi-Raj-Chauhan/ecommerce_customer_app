import 'package:ecommerce_customer/MODELS/address.dart';
import 'package:ecommerce_customer/MODELS/orderModel.dart';
import 'package:ecommerce_customer/MODELS/orderModelProduct.dart';
import 'package:ecommerce_customer/MODELS/orderProduct.dart';
import 'package:ecommerce_customer/SERVICES/dioclient.dart';
import 'package:ecommerce_customer/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpecificOrderpage extends StatefulWidget {
  String orderId;
  SpecificOrderpage({required this.orderId, super.key});

  @override
  State<SpecificOrderpage> createState() => _SpecificOrderpageState();
}

class _SpecificOrderpageState extends State<SpecificOrderpage> {
  Future<void> getOrderDetails(String orderId) async {
    try {
      final r = await Dioclient.dio.get('/order/${orderId}');
      final re = r.data;
      print(re);
      final res = re['order'];
      if (r.statusCode == 201 || r.statusCode == 200 || r.statusCode == 301) {
        final List products = res['products'];
        print(products);
        final List<OrderModelProduct> fetchedProds = products
            .map((ele) => OrderModelProduct.fromJson(ele))
            .toList();
        setState(() {
          username = res['user']['name'];
          order = OrderModel.fromJson(res);
          address = Address.fromJson(res['address']);
          orderProducts.addAll(fetchedProds);
          dropDownValue = order.status;
          isLoading = false;
        });
      } else {}
    } catch (e, stack) {
      debugPrint('ERROR IN getOrderDetails: $e');
      debugPrint(stack.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  late String username;
  bool isLoading = true;
  late OrderModel order;
  late Address address;
  List<OrderModelProduct> orderProducts = [];
  String dropDownValue = "Pending";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOrderDetails(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order',
                  style: GoogleFonts.nunito(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'Placed on - ',
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                    Icon(Icons.calendar_month, size: 12, color: Theme.of(context).colorScheme.onBackground),
                    Text(
                      '${order.createdAt}',
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                basicInfoContainer(),
                const SizedBox(height: 20),
                orderItemsContainer(orderProducts),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget basicInfoContainer() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(15),
        color: Theme.of(context).colorScheme.surface,
        child: Container(
          margin: EdgeInsets.all(15),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Basic Info',
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Divider(color: Theme.of(context).colorScheme.secondary),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [rowTitle('Customer'), customerContent()],
                ),
                Divider(color: Theme.of(context).colorScheme.secondary),
                Row(children: [rowTitle('Id'), rowContent('${order.id}', false)]),
                Divider(color: Theme.of(context).colorScheme.secondary),
                Row(
                  children: [
                    rowTitle('Date & Time'),
                    rowContent('${order.createdAt}', false),
                  ],
                ),
                Divider(color: Theme.of(context).colorScheme.secondary),
                Row(
                  children: [
                    rowTitle('Total Amount'),
                    rowContent('${order.totalAmount}', false),
                  ],
                ),
                Divider(color: Theme.of(context).colorScheme.secondary,),
                Row(
                  children: [
                    rowTitle('Status'),
                    rowContent('${order.status}', true),
                  ],
                ),
                Divider(color: Theme.of(context).colorScheme.secondary),
          
                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget orderItemsContainer(List<OrderModelProduct> orderProducts) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        elevation: 8,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          margin: EdgeInsets.all(15),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order items',
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 10),
                Divider(color: Theme.of(context).colorScheme.secondary),
          
                /// TABLE HEADER
                tableRow(description: 'Product Name', paymentType: 'Payment Method', amount: "Amount", isHeader: true),
                Divider(color: Theme.of(context).colorScheme.secondary),
          
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) => Divider(color: Theme.of(context).colorScheme.secondary),
                  itemCount: orderProducts.length,
                  itemBuilder: (BuildContext context, int index) {
                    return tableRow(
                      description:
                          '${orderProducts[index].name}X${orderProducts[index].quantity}',
                      paymentType: "COD",
                      amount:
                          '${orderProducts[index].priceAtPurchase * orderProducts[index].quantity}',
                    );
                  },
                ),
          
                const SizedBox(height: 10),
                Divider(color: Theme.of(context).colorScheme.secondary),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget tableRow({
    required String description,
    required String paymentType,
    required String amount,
    bool isHeader = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        
        children: [
          Expanded(
            flex: 5,
            child: Text(
              description,
              style: GoogleFonts.nunito(
                fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                color: isHeader ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              paymentType,
              style: GoogleFonts.nunito(
                fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                color: isHeader ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              amount,
              textAlign: TextAlign.end,
              style: GoogleFonts.nunito(
                fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                color: isHeader ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget rowTitle(String title) {
    return Expanded(
      flex: 4,
      child: Text(
        title,
        style: GoogleFonts.nunito(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
  
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
  
  Widget rowContent(String text, bool isStatus) {
    return Expanded(
      flex: 8, 
      child: Text(
        text, 
        style: GoogleFonts.nunito(
          color: isStatus ? statusColor(text) : Theme.of(context).colorScheme.onSurface
        )
      )
    );
  }

  Widget customerContent() {
    return Expanded(
      flex: 8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            username,
            style: GoogleFonts.nunito(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          Text(
            address.line1, 
            style: GoogleFonts.nunito(color: Theme.of(context).colorScheme.secondary)
          ),
          Text(
            '${address.line2} , ${address.city}',
            style: GoogleFonts.nunito(color: Theme.of(context).colorScheme.secondary),
          ),
          Text(
            '${address.state}, ${address.postalCode}, ${address.country}',
            style: GoogleFonts.nunito(color: Theme.of(context).colorScheme.secondary),
          ),
        ],
      ),
    );
  }
}