import 'dart:async';

import 'package:ecommerce_customer/MODELS/HomeProducts.dart';
import 'package:ecommerce_customer/PAGES/productpage.dart';
import 'package:ecommerce_customer/SERVICES/dioclient.dart';
import 'package:ecommerce_customer/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchQuery = TextEditingController();
  Timer? debounce;

  List<HomeProducts> products = [];
  bool isLoading = false;

  @override
  void dispose() {
    debounce?.cancel();
    _searchQuery.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          toolbarHeight: 80,
          title: _searchTextField(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Builder(
            builder: (context) {
              // 1️⃣ Loading → skeleton ONLY
              if (isLoading) {
                return listSkeleton();
              }

              // 2️⃣ Search results
              if (products.isNotEmpty) {
                return _suggestionsList();
              }

              // 3️⃣ Default empty state
              return emptySearchState();
            },
          ),
        ),
      ),
    );
  }

  // ================= SEARCH BAR =================
  Widget _searchTextField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.transparent,
        child: TextField(
          textInputAction: TextInputAction.search,
          onSubmitted: (_) {
            String q = _searchQuery.text.trim();
            if (q.isEmpty) return;
            context.push('/search/list?q=$q');
          },
          controller: _searchQuery,
          onChanged: (value) {
            if (debounce?.isActive ?? false) debounce!.cancel();

            debounce = Timer(
              const Duration(milliseconds: 400),
              () => _searchProducts(value),
            );
          },
          decoration: InputDecoration(
            prefixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                final q = _searchQuery.text.trim();
                if (q.isEmpty) return;
                context.push('/search/list?q=$q');
              },
            ),
            hintText: 'Search products...',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: CustomerTheme.accent),
            ),
          ),
        ),
      ),
    );
  }

  // ================= API CALL =================
  Future<void> _searchProducts(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        products.clear();
      });
      return;
    }

    setState(() => isLoading = true);

    try {
      final res = await Dioclient.dio.get(
        '/search/product',
        queryParameters: {'query': query, 'limit': 6},
      );

      setState(() {
        products = List<HomeProducts>.from(
          res.data.map((e) => HomeProducts.fromJson(e)),
        );
      });
    } catch (e) {
      debugPrint("Search error: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  // ================= SUGGESTIONS LIST =================
  Widget _suggestionsList() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(blurRadius: 6, color: Colors.black12)],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: products.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final product = products[index];
          String productThumbnail = "";
          if (product.thumbnail == null) {
            productThumbnail = "https://dummyjson.com/image/15";
          } else {
            productThumbnail = product.thumbnail!;
          }
          return ListTile(
            leading: Image.network(productThumbnail),

            title: Text(
              product.name,
              maxLines: 1,
              style: GoogleFonts.nunito(),
              overflow: TextOverflow.ellipsis,
            ),

            subtitle: Text("₹${product.price}", style: GoogleFonts.nunito()),

            onTap: () {
              /// Clear suggestions
              setState(() {
                products.clear();
                _searchQuery.clear();
              });

              context.push('/product/${product.id}');
            },
          );
        },
      ),
    );
  }

  Widget listSkeleton() {
    return Skeletonizer(
      enableSwitchAnimation: true,
      child: ListView.separated(
        itemCount: 5,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (_, __) {
          return ListTile(
            leading: const Icon(Icons.image),
            title: Text(
              'THIS IS THE TITLE ',
              maxLines: 1,
              style: GoogleFonts.nunito(),
              overflow: TextOverflow.ellipsis,
            ),

            subtitle: Text("₹98991", style: GoogleFonts.nunito()),
          );
        },
      ),
    );
  }

  Widget emptySearchState() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Popular Searches ❤️‍🔥',
            style: GoogleFonts.nunito(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),

          ...popularProducts.map((product) {
            return ListTile(
              leading: const Icon(Icons.trending_up, color: Colors.orange),
              title: Text(
                product['name'],
                style: GoogleFonts.nunito(fontWeight: FontWeight.w600),
              ),
              onTap: () {
                _searchQuery.text = product['name'];
                _searchProducts(product['name']);
              },
            );
          }).toList(),
        ],
      ),
    );
  }

  final List<Map<String, dynamic>> popularProducts = [
    {"name": "Men Solid T-Shirt"},
    {"name": "Running Shoes"},
    {"name": "Wireless Headphones"},
    {"name": "Casual Backpack"},
    {"name": "Smart Watch"},
  ];
}
