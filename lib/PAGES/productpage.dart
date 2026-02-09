import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommerce_customer/COMPONENTS/AuthDialog.dart';
import 'package:ecommerce_customer/MODELS/DetailedProduct.dart';
import 'package:ecommerce_customer/PAGES/checkoutpage.dart';
import 'package:ecommerce_customer/PROVIDER/CartProvider.dart';
import 'package:ecommerce_customer/SERVICES/dioclient.dart';
import 'package:ecommerce_customer/SERVICES/flutterSecureStorage.dart';
import 'package:ecommerce_customer/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Productpage extends StatefulWidget {
  final String productId;
  const Productpage({required this.productId, super.key});

  @override
  State<Productpage> createState() => _ProductpageState();
}

Future<DetailedProduct?> getProductDetails(String prodId) async {
  try {
    var res = await Dioclient.dio.get('/product/${prodId}');
    if (res.statusCode == 200 || res.statusCode == 201) {
      return DetailedProduct.fromJson(res.data['product']);
    } else {
      return null;
    }
  } catch (e) {
    debugPrint('FETCH PRODUCT ERROR: $e');
    return null;
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

class _ProductpageState extends State<Productpage> {
  late Future<DetailedProduct?> currentProduct;
  bool wantsLogin = true;
  int cartCount = 0;
  @override
  void initState() {
    super.initState();
    currentProduct = getProductDetails(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = deviceWidth >= 900;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: CustomerTheme.accent),
      ),

      bottomSheet: isDesktop
          ? null
          : FutureBuilder(
              future: currentProduct,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _skeleton();
                }

                if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(child: Text("Product not found"));
                }

                final product = snapshot.data!;

                return actionButtons(wantsLogin, product);
              },
            ),
      body: FutureBuilder<DetailedProduct?>(
        future: currentProduct,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _skeleton();
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Product not found"));
          }

          final product = snapshot.data!;
          final List<String> images = List<String>.from(
            product.imageURLs ?? [],
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: !isDesktop
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// ✅ FIXED HEIGHT CAROUSEL
                      SizedBox(
                        height: 320,
                        child: productImageCarousel(images),
                      ),

                      _details(product),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// LEFT: IMAGE
                      Expanded(
                        flex: 5,
                        child: SizedBox(
                          height: 320,
                          child: productImageCarousel(images),
                        ),
                      ),

                      const SizedBox(width: 24),

                      /// RIGHT: DETAILS
                      Expanded(
                        flex: 5,
                        child: Column(
                          children: [
                            _details(product),
                            SizedBox(height: 100),
                            actionButtons(wantsLogin, product),
                          ],
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }

  Widget cartButton(BuildContext context, String prodId) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, _) {
        final cartCount = cartProvider.getCurrentCount(prodId);

        return cartCount != 0
            ? Row(
                children: [
                  // decrement
                  GestureDetector(
                    onTap: () {
                      cartProvider.delteItem(prodId);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadiusGeometry.directional(
                          topStart: Radius.circular(20),
                          bottomStart: Radius.circular(20),
                        ),
                        border: BoxBorder.all(
                          color: CustomerTheme.accent,
                          width: 1,
                        ),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: const Text("-", style: TextStyle(color: CustomerTheme.accent),),
                      ),
                    ),
                  ),

                  // quantity
                  Container(
                    decoration: BoxDecoration(
                      border: BoxBorder.symmetric(
                        horizontal: BorderSide(
                          color: Colors.grey.shade400,
                          width: 1,
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                      child: Text("$cartCount"),
                    ),
                  ),

                  // increment
                  GestureDetector(
                    onTap: () {
                      cartProvider.addItemToCart(prodId);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadiusGeometry.directional(
                          topEnd: Radius.circular(20),
                          bottomEnd: Radius.circular(20),
                        ),
                        color: CustomerTheme.accent,
                        border: BoxBorder.all(color: CustomerTheme.accent),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: const Text(
                          "+",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : OutlinedButton(
                onPressed: () {
                  cartProvider.addItemToCart(prodId);
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                  side: const BorderSide(color: Colors.red),
                ),
                child: Text(
                  "Add to Cart",
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
              );
      },
    );
  }

  Widget _details(DetailedProduct product) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.name,
            style: GoogleFonts.nunito(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            product.weight ?? "",
            style: const TextStyle(color: Colors.black45),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
            child: Row(
              children: [
                Text(
                  "₹${product.price}",
                  style: GoogleFonts.nunito(
                    fontSize: 15,
                    color: Colors.redAccent,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(width: 7),
                Text(
                  "-${product.discountPercent}%",
                  style: GoogleFonts.nunito(
                    fontSize: 15,
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Text(
            "₹${product.discountedPrice}",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 18),
          Text('Description', style:  GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.bold),),
          const SizedBox(height: 10),
          Text(
            product.description ?? "",
            style: const TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _skeleton() {
    return Skeletonizer(
      child: Column(
        children: [
          Container(height: 320, color: Colors.grey),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text("Loading product..."),
          ),
        ],
      ),
    );
  }

  /// ----------------- ACTION ------------------
  Widget actionButtons(bool wantsLogin, DetailedProduct product) {
    return SafeArea(
      child: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// BUY NOW
            ElevatedButton(
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
                      return AuthDialog(
                        context: context,
                        wantsLogin: wantsLogin,
                      );
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: Text(
                "Buy Now",
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 16),

            /// ADD TO CART
            cartButton(context, product.id),
          ],
        ),
      ),
    );
  }

  /// ---------------- CAROUSEL ----------------

  Widget productImageCarousel(List<String> images) {
    if (images.isEmpty) {
      return Container(
        color: Colors.grey.shade100,
        child: const Icon(Icons.image, size: 80),
      );
    }
    final String api_url = dotenv.env['API_URL']!;
    return CarouselSlider(

      items: images.map((url) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.network("${url}", width: double.infinity, fit: BoxFit.cover),
        );
      }).toList(),
      options: CarouselOptions(

        height: 320,
        enlargeCenterPage: false, // WEB SAFE
        enableInfiniteScroll: true,
        autoPlay: true,
      ),
    );
  }
}
