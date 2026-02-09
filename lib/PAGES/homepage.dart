import 'package:ecommerce_customer/COMPONENTS/AuthDialog.dart';
import 'package:ecommerce_customer/COMPONENTS/skeletonizer.dart';
import 'package:ecommerce_customer/FireBase%20Services/notification_service.dart';
import 'package:ecommerce_customer/MODELS/HomeProducts.dart';
import 'package:ecommerce_customer/PROVIDER/CartProvider.dart';
import 'package:ecommerce_customer/PROVIDER/HomeProductsProvider.dart';
import 'package:ecommerce_customer/PROVIDER/NotificationProvider.dart';
import 'package:ecommerce_customer/SERVICES/dioclient.dart';
import 'package:ecommerce_customer/SERVICES/getUserInstance.dart';
import 'package:ecommerce_customer/theme/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool wantsLogin = true;
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.microtask(() {
      context.read<HomeProductsProvider>().fetchProducts();
    });
    if (!kIsWeb) {
      final fcmToken = NotificationService().getDeviceToken().then((value) {
        print("FCMToken $value");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   // toolbarHeight: 70,
        //   backgroundColor: Colors.white,
        //   elevation: 0,
        //   flexibleSpace: _customHeader(),
        // ),
        body: RefreshIndicator(
          onRefresh: () async {
            await context.read<HomeProductsProvider>().fetchProducts(
              forceRefresh: true,
            );
          },
          child: Consumer<HomeProductsProvider>(
            builder: (context, provider, _) {
              if (provider.isLoading) {
                return LoadingScreen();
              }
      
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // const SizedBox(height: 5,),
                       _customHeader(),
                      const SizedBox(height: 20,),
                      _section('New Arrivals 🚀', provider.newArrivals),
                      _section('Hot Picks 🔥', provider.hotProducts),
                      _section('Top Sellers 📈', provider.topSellers),
                      _section('On Sale 👜', provider.topDiscounts),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget actionButtons(bool wantsLogin, HomeProducts product) {
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
                        child: const Text(
                          "-",
                          style: TextStyle(color: CustomerTheme.accent),
                        ),
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

  Widget _section(String title, List homeprods) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.nunito(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: homeprods.map((product) {
              return _productCard(product, context);
            }).toList(),
          ),
        ),
      ],
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
      },
      child: Text(
        'Login Now !',
        style: GoogleFonts.nunito(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(backgroundColor: CustomerTheme.accent),
    );
  }

Widget _customHeader() {
    String? userName = context.watch<User>().user?.name;
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const CircleAvatar(child: Icon(Icons.person)),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      userName != null
                          ? Text(
                              'Hi, ${userName}',
                              style: GoogleFonts.nunito(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : loginButton(),

                      Padding(
                        padding: userName == null
                            ? EdgeInsets.symmetric(horizontal: 18.0)
                            : EdgeInsets.all(0),
                        child: Text(
                          "Let's go shopping",
                          style: GoogleFonts.nunito(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  // Notification button with badge
                  Consumer<NotificationProvider>(
                    builder: (context, notificationProvider, _) {
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          IconButton(
                            onPressed: () {
                              // Clear badge when opening notifications
                              notificationProvider.clearUnread();
                              context.push('/notifications');
                            },
                            icon: const Icon(Icons.notifications_none_rounded),
                          ),
                          // Badge
                          if (notificationProvider.hasUnread)
                            Positioned(
                              right: 8,
                              top: 8,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: Text(
                                  notificationProvider.unreadCount > 9
                                      ? '9+'
                                      : '${notificationProvider.unreadCount}',
                                  style: GoogleFonts.nunito(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _productCard(HomeProducts product, BuildContext context) {
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GestureDetector(
        onTap: () => {context.push('/product/${product.id}')},
        child: Card(
          elevation: 4,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: SizedBox(
            height: 380,
            width: 220,
            child: Column(
              children: [
                // Image section with gradient overlay
                Expanded(
                  flex: 5,
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                          color: Colors.grey.shade100,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                          child: (url == null || url == "")
                              ? const Icon(
                                  Icons.image,
                                  size: 80,
                                  color: Colors.grey,
                                )
                              : Image.network(url, fit: BoxFit.cover),
                        ),
                      ),
                      // Discount badge
                      if (product.discountPercent != null &&
                          product.discountPercent != 0)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '-${product.discountPercent}',
                              style: GoogleFonts.nunito(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Product details section
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Brand
                        Text(
                          product.brand,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.nunito(
                            color: Colors.grey.shade600,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Product name
                        Text(
                          product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.nunito(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Price section
                        Row(
                          children: [
                            Text(
                              '₹${product.discountedPrice}',
                              style: GoogleFonts.nunito(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '₹${product.price}',
                              style: GoogleFonts.nunito(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),

                        // Action buttons
                        Row(
                          children: [
                            // Buy Now button
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  bool isLoggedin = false;
                                  bool check = await checkAuth();
                                  setState(() {
                                    isLoggedin = check;
                                  });
                                  if (!isLoggedin) {
                                    final bool? authSuccess =
                                        await showDialog<bool>(
                                          context: context,
                                          builder: (context) {
                                            return AuthDialog(
                                              context: context,
                                              wantsLogin: wantsLogin,
                                            );
                                          },
                                        );

                                    if (authSuccess != true) return;

                                    check = await checkAuth();
                                    setState(() {
                                      isLoggedin = check;
                                    });
                                  } else {
                                    context.push(
                                      '/checkout',
                                      extra: product.id,
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  backgroundColor: CustomerTheme.accent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
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

                            // Add to cart button/counter
                            _cartButtonCompact(context, product.id),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _cartButtonCompact(BuildContext context, String prodId) {
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
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    side: BorderSide(color: CustomerTheme.accent, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
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
}