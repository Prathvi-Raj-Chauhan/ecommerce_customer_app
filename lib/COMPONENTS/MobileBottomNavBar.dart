import 'package:ecommerce_customer/PROVIDER/CartProvider.dart';
import 'package:ecommerce_customer/SERVICES/logout.dart';
import 'package:ecommerce_customer/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MobileBottomNavBar extends StatefulWidget {
  const MobileBottomNavBar({super.key});

  @override
  State<MobileBottomNavBar> createState() => _MobileBottomNavBarState();
}

class _MobileBottomNavBarState extends State<MobileBottomNavBar> {
  int _locationToIndex(String? location) {
    String? finalString = location;
    if (location == null) {
      finalString = "";
    }
    if (finalString!.startsWith('/search')) return 1;
    if (finalString.startsWith('/cart')) return 2;
    if (finalString.startsWith('/profile')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location =
        GoRouter.of(context).routerDelegate.currentConfiguration?.fullPath ??
        '/';
    print(location);
    int currentPageIndex = _locationToIndex(
      location,
    ); // after switching the page we have to also select the icon at bottom bar according to the page we are on
    return Consumer<CartProvider>(
      builder: (context, cartProvider, _) {
        int cartSize = 0;
        if (cartProvider.cart.isEmpty != 0) {
          cartSize = cartProvider.length;
        }
        return NavigationBar(
          selectedIndex: currentPageIndex,
          indicatorColor: CustomerTheme.accent,
          onDestinationSelected: (int index) {
            switch (index) {
              case 0:
                setState(() {
                  currentPageIndex = 0;
                });
                context.go('/');
                break;
              case 1:
                setState(() {
                  currentPageIndex = 1;
                });
                context.go('/search');
                break;
              case 2:
                setState(() {
                  currentPageIndex = 2;
                });
                context.go('/cart');
                break;
              case 3:
                setState(() {
                  currentPageIndex = 3;
                });
                context.go('/profile');
                break;
            }
          },
          destinations: <Widget>[
            NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
            NavigationDestination(
              icon: Badge(
                label: Text('${cartSize}'),
                child: Icon(Icons.shopping_bag_outlined),
              ),
              label: 'Cart',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_2_rounded),

              label: 'Profile',
            ),
          ],
        );
      },
    );
  }
}
