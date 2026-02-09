import 'dart:async';

import 'package:ecommerce_customer/COMPONENTS/AuthDialog.dart';
import 'package:ecommerce_customer/MODELS/HomeProducts.dart';
import 'package:ecommerce_customer/PROVIDER/CartProvider.dart';
import 'package:ecommerce_customer/SERVICES/dioclient.dart';
import 'package:ecommerce_customer/theme/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SearchResultPage extends StatefulWidget {
  final String query;
  const SearchResultPage({super.key, required this.query});

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<HomeProducts> products = [];
  List<HomeProducts> suggested = [];
  bool isLoading = false;
  bool hasMore = true;
  int page = 1;
  bool wantsLogin = true;
  Timer? debounce;

  // ================= FILTERS =================
  double? minPrice;
  double? maxPrice;

  List<Map<String, dynamic>> categories = [];
  String? selectedCategory; // category name or id

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.query;
    fetchProducts();
    fetchCategories();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          hasMore &&
          !isLoading) {
        fetchProducts();
      }
    });
  }

  @override
  void dispose() {
    debounce?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ================= API =================
  Future<void> fetchProducts({bool reset = false}) async {
    if (reset) {
      page = 1;
      products.clear();
      hasMore = true;
    }

    setState(() => isLoading = true);

    try {
      final res = await Dioclient.dio.get(
        '/search/product/list',
        queryParameters: {
          'query': _searchController.text.trim(),
          'page': page,
          'limit': 10,
          'minPrice': minPrice,
          'maxPrice': maxPrice,
          'category': selectedCategory,
        },
      );

      final fetched = List<HomeProducts>.from(
        res.data.map((e) => HomeProducts.fromJson(e)),
      );

      setState(() {
        page++;
        products.addAll(fetched);
        if (fetched.length < 10) hasMore = false;
      });
    } catch (e) {
      debugPrint("Search error: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<bool> checkAuth() async {
    var res = await Dioclient.dio.get('/auth-check');
    if (res.statusCode == 401) {
      return false;
    }
    if (res.data['status'] == true) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> fetchCategories() async {
    try {
      final res = await Dioclient.dio.get('/search/category');
      setState(() {
        categories = List<Map<String, dynamic>>.from(res.data['data']);
        print(categories);
      });
    } catch (e) {
      debugPrint("Category fetch error: $e");
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F8F8),
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.only(top: 8),
            itemCount: products.length + (hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == products.length) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final product = products[index];
              String? url = "";
              if (product.thumbnail != null) {
                if (product.thumbnail != "https://dummyjson.com/image/150") {
                  if (!kIsWeb) {
                    url = "${product.thumbnail}";
                  } else {
                    url = "${product.thumbnail}";
                  }
                }
              }
              return InkWell(
                onTap: () => context.push('/product/${product.id}'),
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      // Image Section
                      Container(
                        width: 120,
                        height: 140,
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: (url == null || url == "")
                              ? const Icon(
                                  Icons.image,
                                  size: 50,
                                  color: Colors.grey,
                                )
                              : Image.network(url, fit: BoxFit.cover),
                        ),
                      ),

                      // Content Section
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(4, 12, 12, 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Brand
                              Text(
                                product.brand,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.nunito(
                                  fontSize: 11,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 2),

                              // Product Name
                              Text(
                                product.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.nunito(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 6),

                              // Price Section
                              Row(
                                children: [
                                  Text(
                                    "₹${product.discountedPrice}",
                                    style: GoogleFonts.nunito(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "₹${product.price}",
                                    style: GoogleFonts.nunito(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                  if (product.discountPercent != null &&
                                      product.discountPercent != 0)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 6),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade50,
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        child: Text(
                                          "-${product.discountPercent}",
                                          style: GoogleFonts.nunito(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.green.shade700,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              // Action Buttons
                              actionButtons(false, product),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          _suggestionsList(),
        ],
      ),
    );
  }

  Widget actionButtons(bool wantsLogin, HomeProducts product) {
    return Row(
      children: [
        // BUY NOW
        Expanded(
          child: ElevatedButton(
            onPressed: () async {
              bool isLoggedin = false;
              bool check = await checkAuth();
              setState(() {
                isLoggedin = check;
              });
              if (!isLoggedin) {
                final bool? authSuccess = await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AuthDialog(context: context, wantsLogin: wantsLogin);
                  },
                );

                // dialog dismissed or failed
                if (authSuccess != true) return;

                // 🔥 user JUST logged in
                check = await checkAuth();
                setState(() {
                  isLoggedin = check;
                });
              } else {
                context.push('/checkout', extra: product.id);
              }
              // TODO: CALL the api for buying product and proceed with UI
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              backgroundColor: CustomerTheme.accent,
            ),
            child: Text(
              "Buy",
              style: GoogleFonts.nunito(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),

        // ADD TO CART
        cartButton(context, product.id),
      ],
    );
  }

  Widget cartButton(BuildContext context, String prodId) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, _) {
        final cartCount = cartProvider.getCurrentCount(prodId);

        return cartCount != 0
            ? Container(
                decoration: BoxDecoration(
                  border: Border.all(color: CustomerTheme.accent, width: 1.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Decrement
                    InkWell(
                      onTap: () {
                        cartProvider.delteItem(prodId);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        child: Icon(
                          Icons.remove,
                          size: 16,
                          color: CustomerTheme.accent,
                        ),
                      ),
                    ),

                    // Count
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Text(
                        "$cartCount",
                        style: GoogleFonts.nunito(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    // Increment
                    InkWell(
                      onTap: () {
                        cartProvider.addItemToCart(prodId);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: CustomerTheme.accent,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(6),
                            bottomRight: Radius.circular(6),
                          ),
                        ),
                        child: Icon(Icons.add, size: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              )
            : Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    cartProvider.addItemToCart(prodId);
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    side: BorderSide(color: CustomerTheme.accent, width: 1.5),
                  ),
                  child: Icon(
                    Icons.shopping_cart_outlined,
                    size: 18,
                    color: CustomerTheme.accent,
                  ),
                ),
              );
      },
    );
  }

  // ================= SEARCH BAR =================
  Widget _searchTextField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.white,
        child: TextField(
          textInputAction: TextInputAction.search,
          onSubmitted: (_) {
            String q = _searchController.text.trim();
            if (q.isEmpty) return;
            context.push('/search/list?q=$q');
          },
          controller: _searchController,
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
                final q = _searchController.text.trim();
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
        suggested.clear();
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
        suggested = List<HomeProducts>.from(
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(blurRadius: 6, color: Colors.black12)],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: suggested.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final product = suggested[index];

          return ListTile(
            leading: const Icon(Icons.image),

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
                suggested.clear();
                _searchController.clear();
              });

              context.push('/product/${product.id}');
            },
          );
        },
      ),
    );
  }

  // ================= APP BAR =================
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      iconTheme: const IconThemeData(color: Colors.black),
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: TextField(
          onChanged: (value) {
            if (debounce?.isActive ?? false) debounce!.cancel();

            debounce = Timer(
              const Duration(milliseconds: 400),
              () => _searchProducts(value),
            );
          },
          controller: _searchController,
          textInputAction: TextInputAction.search,
          onSubmitted: (_) => fetchProducts(reset: true),
          decoration: InputDecoration(
            hintText: 'Search products...',
            filled: true,
            fillColor: const Color(0xffF2F2F2),
            prefixIcon: const Icon(Icons.search, color: Colors.black54),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: _openFilterSheet,
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: CustomerTheme.accent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.tune, color: CustomerTheme.accent),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  // ================= FILTER SHEET =================
  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            16,
            16,
            MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filters',
                style: GoogleFonts.nunito(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              // ===== CATEGORY =====
              Text(
                'Category',
                style: GoogleFonts.nunito(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),

              Wrap(
                spacing: 8,
                children: categories.map((cat) {
                  final isSelected = selectedCategory == cat['name'];

                  return ChoiceChip(
                    label: Text(cat['name']),
                    selected: isSelected,
                    selectedColor: CustomerTheme.accent.withOpacity(0.2),
                    onSelected: (_) {
                      setState(() {
                        selectedCategory = isSelected ? null : cat['name'];
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),

              TextField(
                decoration: _inputDecoration('Min Price'),
                keyboardType: TextInputType.number,
                onChanged: (v) => minPrice = double.tryParse(v),
              ),

              const SizedBox(height: 12),

              TextField(
                decoration: _inputDecoration('Max Price'),
                keyboardType: TextInputType.number,
                onChanged: (v) => maxPrice = double.tryParse(v),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomerTheme.accent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    fetchProducts(reset: true);
                  },
                  child: Text(
                    'Apply Filters',
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: const Color(0xffF6F6F6),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}
