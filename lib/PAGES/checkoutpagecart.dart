import 'package:ecommerce_customer/MODELS/DetailedProduct.dart';
import 'package:ecommerce_customer/MODELS/address.dart';
import 'package:ecommerce_customer/MODELS/cartProduct.dart';
import 'package:ecommerce_customer/PROVIDER/CartProvider.dart';
import 'package:ecommerce_customer/SERVICES/dioclient.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CheckoutPageCart extends StatefulWidget {
  const CheckoutPageCart({super.key});

  @override
  State<CheckoutPageCart> createState() => _CheckoutPageCartState();
}

class _CheckoutPageCartState extends State<CheckoutPageCart> {
  late Future<List<DetailedProduct>> _productsFuture;
  late Future<List<Address>> _addressFuture;

  Address? selectedAddress;

  @override
  void initState() {
    super.initState();
    context.read<CartProvider>().fetchCartProducts();
    _addressFuture = fetchUserAddresses();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Checkout',
          style: GoogleFonts.nunito(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        actionsIconTheme: IconThemeData(color: Colors.black),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, _) {
          if (cartProvider.cart.isEmpty) {
            return const Center(
              child: Text(
                "Your cart was empty 🛒",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _productList(cartProvider.cart),
                  const SizedBox(height: 15),
                  _addressSection(),
                  const SizedBox(height: 15),
                  _summarySection(cartProvider.cart),
                  const SizedBox(height: 15),
                  _placeOrderButton(cartProvider.cart),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _productList(List<CartProduct> products) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: products.length,
      separatorBuilder: (_, __) => const Divider(color: Colors.grey),
      itemBuilder: (context, index) {
        final product = products[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child:
                    product.product.imageURLs.isNotEmpty &&
                        product.product.imageURLs[0] != null &&
                        product.product.imageURLs[0].isNotEmpty
                    ? Image.network(
                        product.product.imageURLs[0],
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) =>
                            const Icon(Icons.image_not_supported),
                      )
                    : const Icon(Icons.image, size: 60),
              ),

              const SizedBox(width: 12),

              // Product name
              Expanded(
                child: Text(
                  product.product.name,
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Price column
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₹${product.product.price}',
                    style: GoogleFonts.nunito(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.redAccent,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '₹${product.product.discountedPrice}',
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.green,
                    ),
                  ),
                  Text(
                    'x${product.quantity} = '
                    '₹${product.product.discountedPrice * product.quantity}',
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _summarySection(List<CartProduct> products) {
    final totalPrice = products.fold(
      0,
      (sum, p) => sum + p.product.price * p.quantity,
    );
    final discountedTotal = products.fold(
      0,
      (sum, p) => sum + p.product.discountedPrice * p.quantity,
    );

    return Card(
      margin: const EdgeInsets.only(top: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _summaryRow('Items', products.length.toString()),
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

  Widget _placeOrderButton(List<CartProduct> products) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: selectedAddress == null
            ? null
            : () => _showOrderConfirmationDialog(products),
        child: Text(
          'Place Order',
          style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // ---------------- ORDER CONFIRMATION DIALOG ----------------

  void _showOrderConfirmationDialog(List<CartProduct> products) {
    final discountedTotal = products.fold(
      0,
      (sum, p) => sum + p.product.discountedPrice * p.quantity,
    );

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
              // Products List
              Text(
                'Products:',
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              ...products.map(
                (product) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    '• ${product.product.name} (x${product.quantity})',
                    style: GoogleFonts.nunito(fontSize: 14),
                  ),
                ),
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
                    '₹$discountedTotal',
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
            child: Text('Cancel', style: GoogleFonts.nunito()),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _placeOrder();
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

  void _placeOrder() async {
    try {
      var body = {"addressId": selectedAddress!.id};
      final res = await Dioclient.dio.post('/place-order-cart', data: body);

      final data = res.data;
      if (data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Order placed successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to place order'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _addressSection() {
    return FutureBuilder<List<Address>>(
      future: _addressFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final addresses = snapshot.data!;

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
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

                ...addresses.map((address) {
                  return RadioListTile<Address>(
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
                  );
                }),
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
              if (line1.text.isEmpty ||
                  city.text.isEmpty ||
                  state.text.isEmpty ||
                  postal.text.isEmpty) {
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
