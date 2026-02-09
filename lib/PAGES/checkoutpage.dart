import 'package:ecommerce_customer/MODELS/DetailedProduct.dart';
import 'package:ecommerce_customer/MODELS/address.dart';
import 'package:ecommerce_customer/SERVICES/dioclient.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class CheckoutPage extends StatefulWidget {
  final String productId;

  const CheckoutPage({super.key, required this.productId});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late Future<DetailedProduct?> _productFuture;
  late Future<List<Address>> _addressFuture;

  Address? selectedAddress;

  @override
  void initState() {
    super.initState();
    _productFuture = getProductDetails(widget.productId);
    _addressFuture = fetchUserAddresses();
  }

  // ---------------- API CALLS ----------------

  Future<DetailedProduct?> getProductDetails(String prodId) async {
    try {
      final res = await Dioclient.dio.get('/product/$prodId');
      if (res.statusCode == 200 || res.statusCode == 201) {
        return DetailedProduct.fromJson(res.data['product']);
      }
    } catch (e) {
      debugPrint('FETCH PRODUCT ERROR: $e');
    }
    return null;
  }

  Future<List<Address>> fetchUserAddresses() async {
    try {
      final res = await Dioclient.dio.get('/address');
      return (res.data['addresses'] as List)
          .map((e) => Address.fromJson(e))
          .toList();
    } catch (e) {
      debugPrint('FETCH ADDRESS ERROR: $e');
      return [];
    }
  }

  Future<Address?> addNewAddress(Map<String, dynamic> data) async {
    try {
      final res = await Dioclient.dio.post('/new-address', data: data);
      return Address.fromJson(res.data['address']);
    } catch (e) {
      debugPrint('ADD ADDRESS ERROR: $e');
      return null;
    }
  }

  // ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:  Text('Checkout', style: GoogleFonts.nunito(color: Colors.black, fontWeight: FontWeight.bold),), centerTitle: true, backgroundColor: Colors.white, actionsIconTheme: IconThemeData(color: Colors.black),),
      body: FutureBuilder<DetailedProduct?>(
        future: _productFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Product not found'));
          }

          final product = snapshot.data!;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  _productCard(product),
                  const SizedBox(height: 15),
                  _addressSection(),
                  const SizedBox(height: 15),
                  _summarySection(product),
                  const SizedBox(height: 15),
                  _placeOrderButton(product),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _productCard(DetailedProduct product) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.image, size: 40),
        title: Text(
          product.name,
          style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
        ),
        subtitle: const Text('Quantity: 1'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '₹${product.price}',
              style: GoogleFonts.nunito(
                decoration: TextDecoration.lineThrough,
                color: Colors.redAccent,
              ),
            ),
            Text(
              '₹${product.discountedPrice}',
              style: GoogleFonts.nunito(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summarySection(DetailedProduct product) {
    final totalPrice = product.price;
    final discountedTotal = product.discountedPrice;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _summaryRow('Items', '1'),
            _summaryRow('Total MRP', '₹$totalPrice'),
            _summaryRow(
              'Discount',
              '-₹${totalPrice - discountedTotal}',
              valueColor: Colors.green,
            ),
            const Divider(),
            _summaryRow('Payable Amount', '₹$discountedTotal', isBold: true),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(
    String label,
    String value, {
    bool isBold = false,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.nunito()),
          Text(
            value,
            style: GoogleFonts.nunito(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeOrderButton(DetailedProduct product) {
    return SizedBox(
      width: 500,
      child: ElevatedButton(
        onPressed: selectedAddress == null 
            ? null 
            : () => _showOrderConfirmationDialog(product),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: Text(
          'Place Order',
          style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // ---------------- ORDER CONFIRMATION DIALOG ----------------

  void _showOrderConfirmationDialog(DetailedProduct product) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'Confirm Order',
          style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Name
              Text(
                'Product:',
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                product.name,
                style: GoogleFonts.nunito(fontSize: 14),
              ),
              const SizedBox(height: 12),

              // Delivery Address
              Text(
                'Delivery Address:',
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${selectedAddress!.line1}',
                style: GoogleFonts.nunito(fontSize: 14),
              ),
              if (selectedAddress!.line2.isNotEmpty)
                Text(
                  '${selectedAddress!.line2}',
                  style: GoogleFonts.nunito(fontSize: 14),
                ),
              Text(
                '${selectedAddress!.city}, ${selectedAddress!.state}',
                style: GoogleFonts.nunito(fontSize: 14),
              ),
              Text(
                '${selectedAddress!.postalCode}, ${selectedAddress!.country}',
                style: GoogleFonts.nunito(fontSize: 14),
              ),
              const SizedBox(height: 12),

              // Total Amount
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Amount:',
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '₹${product.discountedPrice}',
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: GoogleFonts.nunito(),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _placeOrder(product);
            },
            child: Text(
              'Confirm Order',
              style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- PLACE ORDER ----------------

  void _placeOrder(DetailedProduct product) async {
    try {
      final res = await Dioclient.dio.post(
        '/place-one-order',
        data: {"productId": product.id, "addressId": selectedAddress!.id},
      );

      if (res.data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Order placed successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/');
      }
    } catch (e) {
      debugPrint('PLACE ORDER ERROR: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to place order'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ---------------- ADDRESS ----------------

  Widget _addressSection() {
    return FutureBuilder<List<Address>>(
      future: _addressFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final addresses = snapshot.data!;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Delivery Address',
                      style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: _openAddAddressDialog,
                      child: const Text('+ Add New'),
                    ),
                  ],
                ),
                ...addresses.map(
                  (address) => RadioListTile<Address>(
                    value: address,
                    groupValue: selectedAddress,
                    onChanged: (val) {
                      setState(() => selectedAddress = val);
                    },
                    title: Text(
                      '${address.line1}, ${address.city}',
                      style: GoogleFonts.nunito(),
                    ),
                    subtitle: Text('${address.state} - ${address.postalCode}'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openAddAddressDialog() {
    final line1 = TextEditingController();
    final line2 = TextEditingController();
    final city = TextEditingController();
    final state = TextEditingController();
    final postal = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add New Address'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: line1,
                decoration: const InputDecoration(labelText: 'Line 1'),
              ),
              TextField(
                controller: line2,
                decoration: const InputDecoration(labelText: 'Line 2'),
              ),
              TextField(
                controller: city,
                decoration: const InputDecoration(labelText: 'City'),
              ),
              TextField(
                controller: state,
                decoration: const InputDecoration(labelText: 'State'),
              ),
              TextField(
                controller: postal,
                decoration: const InputDecoration(labelText: 'Postal Code'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              // Validate fields
              if (line1.text.isEmpty || city.text.isEmpty || 
                  state.text.isEmpty || postal.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please fill all required fields'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              final address = await addNewAddress({
                "line1": line1.text,
                "line2": line2.text,
                "city": city.text,
                "state": state.text,
                "postalCode": postal.text,
                "country": "India",
              });

              if (address != null) {
                // Close the dialog first
                Navigator.pop(dialogContext);
                
                // Update state and show success message
                setState(() {
                  _addressFuture = fetchUserAddresses();
                  selectedAddress = address;
                });
                
                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Address added successfully'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );
              } else {
                // Show error message without closing dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Failed to add address'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}