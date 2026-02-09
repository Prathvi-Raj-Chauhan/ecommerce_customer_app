import 'package:ecommerce_customer/MODELS/DetailedProduct.dart';
import 'package:ecommerce_customer/PAGES/cart.dart';
import 'package:ecommerce_customer/PAGES/checkoutpage.dart';
import 'package:ecommerce_customer/PAGES/checkoutpagecart.dart';
import 'package:ecommerce_customer/PAGES/homepage.dart';
import 'package:ecommerce_customer/PAGES/notificationHistory.dart';
import 'package:ecommerce_customer/PAGES/orderHistoryPage.dart';
import 'package:ecommerce_customer/PAGES/productpage.dart';
import 'package:ecommerce_customer/PAGES/profile.dart';
import 'package:ecommerce_customer/PAGES/search.dart';
import 'package:ecommerce_customer/PAGES/searchresultpage.dart';
import 'package:ecommerce_customer/PAGES/specificOrderPage.dart';
import 'package:ecommerce_customer/SCREEN/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return HomeScreen(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          // builder: (context, state) => HomePage(),
          builder: (context, state) => HomePage(),
        ),
        GoRoute(path: '/search', builder: (context, state) => SearchPage()),
        GoRoute(path: '/cart', builder: (context, state) => CartPage()),
        GoRoute(path: '/profile', builder: (context, state) => ProfilePage()),
        GoRoute(
          path: '/product/:id',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return Productpage(productId: id);
          },
        ),
        GoRoute(
          path: '/search/list',
          builder: (context, state) {
            final query = state.uri.queryParameters['q'] ?? '';
            return SearchResultPage(query: query);
          },
        ),
        GoRoute(
          path: '/checkout',
          builder: (context, state) {
            final ids = state.extra as String;
            return CheckoutPage(productId: ids);
          },
        ),
        GoRoute(
          path: '/orders',
          builder: (context, state) {
            return YourOrders();
          },
        ),
        GoRoute(
          path: '/order/:orderId',
          builder: (context, state) {
            final id = state.pathParameters['orderId']!;
            return SpecificOrderpage(orderId: id);
          },
        ),
        GoRoute(
          path: '/checkout-cart',
          builder: (context, state) {
            return CheckoutPageCart();
          },
        ),
        GoRoute(
          path: '/notifications',
          builder: (context, state) {
            return NotificationHistory();
          },
        ),
      ],
    ),
  ],
);
