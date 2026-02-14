import 'dart:math';

import 'package:ecommerce_customer/COMPONENTS/AuthDialog.dart';
import 'package:ecommerce_customer/MODELS/address.dart';
import 'package:ecommerce_customer/SERVICES/dioclient.dart';
import 'package:ecommerce_customer/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ManageAddressPage extends StatefulWidget {
  const ManageAddressPage({super.key});

  @override
  State<ManageAddressPage> createState() => _ManageAddressPageState();
}

class _ManageAddressPageState extends State<ManageAddressPage> {
  late Future<List<Address>> _addressFuture;
  Address? selectedAddress;
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

  @override
  void initState() {
    super.initState();
    checkAuthAndSetState();
    _addressFuture = fetchUserAddresses();
  }

  Future<void> deleteUserAddress(String id) async {
    try {
      final re = await Dioclient.dio.delete('/address/${id}');
      if (re.statusCode == 200 || re.statusCode == 201) {
      } else {
        print('GOT IN ELSE FOR DELETING ADDRES');
      }
    } catch (e) {
      print("GOT IN CATCH TO DELETE ADDRESS ${e}");
    }
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Manage Your Addresses',
            style: GoogleFonts.nunito(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          centerTitle: true,
          shadowColor: Colors.white,
          backgroundColor: Theme.of(context).colorScheme.surface,
          foregroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          actionsIconTheme: IconThemeData(color: Colors.black),
        ),
        body:  isLoggedin == null
          ? const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            )
          : !isLoggedin!
              ? pleaseLogin()
              : Column(
                children: [
                  _addressSection(),
                ],
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
                  return ListTile(
                    leading: Container(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () async {
                              await deleteUserAddress(address.id);
                              setState(() {
                                _addressFuture = fetchUserAddresses();
                              });
                            },
                            icon: Icon(Icons.delete, color: Colors.redAccent),
                          ),
                          IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
                        ],
                      ),
                    ),
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
