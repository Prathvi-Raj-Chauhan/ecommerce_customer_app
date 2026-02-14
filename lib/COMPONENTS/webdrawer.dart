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
  bool selectHome = false;
  bool selectSearch = false;
  bool selectCart = false;
  bool selectProfile = false;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const BeveledRectangleBorder(),
      child: Container(
        color: Theme.of(context).colorScheme.surface,
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
                        false,
                        selectHome,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(19, 4, 19, 4),
                      child: const Divider(
                        color: Colors.black,
                        height: 0.5,
                        thickness: 0.5,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: HoverableButton(
                        'SEARCH',
                        Icons.search,
                        "search",
                        false,
                        selectSearch,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(19, 4, 19, 4),
                      child: const Divider(
                        color: Colors.black,
                        height: 0.5,
                        thickness: 0.5,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: HoverableButton(
                        'CART',
                        Icons.shopping_cart_checkout,
                        "cart",
                        false,
                        selectCart,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(19, 4, 19, 4),
                      child: const Divider(
                        color: Colors.black,
                        height: 0.5,
                        thickness: 0.5,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: HoverableButton(
                        'PROFILE',
                        Icons.person_2_rounded,
                        "profile",
                        false,
                        selectProfile,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(19, 4, 19, 4),
                      child: const Divider(
                        color: Colors.black,
                        height: 0.5,
                        thickness: 0.5,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: HoverableButton(
                        'LOG OUT',
                        Icons.logout,
                        "",
                        true,
                        false,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(19, 4, 19, 4),
                      child: const Divider(
                        color: Colors.black,
                        height: 0.5,
                        thickness: 0.5,
                      ),
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

  Widget HoverableButton(
    String content,
    IconData icon,
    String dest,
    bool isLogout,
    bool isSelected,
  ) {
    return Material(
      color: isSelected 
        ? Theme.of(context).colorScheme.surface 
        : Colors.transparent,
      borderRadius: BorderRadius.circular(12),

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: InkWell(
          onTap: () {
            setState(() {
            // Resetting all selections
            selectHome = false;
            selectSearch = false;
            selectCart = false;
            selectProfile = false;
            
            // Setting based on selection
            if (dest == "") {
              selectHome = true;
            } else if (dest == "search") {
              selectSearch = true;
            } else if (dest == "cart") {
              selectCart = true;
            } else if (dest == "profile") {
              selectProfile = true;
            }
          });
            if (!isLogout) {
              context.go('/$dest');
            } else {
              print("logout tapped");
              logoutweb(context);
            }
          },
          borderRadius: BorderRadius.circular(12),
          hoverColor: Theme.of(context).colorScheme.secondary,

          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    content,
                    style: GoogleFonts.nunito(
                      fontSize: 16,
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
