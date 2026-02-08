import 'package:ecommerce_customer/SERVICES/logoutweb.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class WebDrawer extends StatefulWidget {
  const WebDrawer({super.key});

  @override
  State<WebDrawer> createState() => _WebDrawerState();
}

class _WebDrawerState extends State<WebDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const BeveledRectangleBorder(),
      child: Container(
        color: Theme.of(context).colorScheme.onSurface,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Brand.',
                  style: GoogleFonts.nunito(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: HoverableButton(
                        'HOME',
                        Icons.home,
                        "",
                        false
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: HoverableButton('SEARCH', Icons.search, "search",
                        false),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: HoverableButton(
                        'CART',
                        Icons.shopping_cart_checkout,
                        "cart",
                        false
                        
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: HoverableButton(
                        'PROFILE',
                        Icons.person_2_rounded,
                        "profile",
                        false
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: HoverableButton('LOG OUT', Icons.logout, "",
                        true),
                      
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget HoverableButton(String content, IconData icon, String dest, bool isLogout) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: InkWell(
          onTap: () => {
            if(!isLogout){
              context.go('/$dest')
            }
            else{
              print("logout tapped"),
              logoutweb(context)
            }
          },
          borderRadius: BorderRadius.circular(12),
          hoverColor: Theme.of(context).colorScheme.onBackground,

          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: Theme.of(context).colorScheme.onPrimary,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    content,
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
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
}