import 'package:ecommerce_customer/COMPONENTS/MobileBottomNavBar.dart';
import 'package:ecommerce_customer/COMPONENTS/webdrawer.dart';
import 'package:ecommerce_customer/PAGES/cart.dart';
import 'package:ecommerce_customer/PAGES/homepage.dart';
import 'package:ecommerce_customer/PAGES/profile.dart';
import 'package:ecommerce_customer/PAGES/search.dart';
import 'package:ecommerce_customer/theme/theme.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final Widget child;
  const HomeScreen({required this.child, super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomePage(),
      SearchPage(),
      CartPage(),
      ProfilePage(),
    ];
    final deviceWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = deviceWidth >= 900;
    return Scaffold(
      body: Row(
        children: [
          if (isDesktop) WebDrawer(),
          Expanded(child: widget.child),
        ],
      ),
      bottomNavigationBar: isDesktop ? null : MobileBottomNavBar(),
    );
  }

 
}
