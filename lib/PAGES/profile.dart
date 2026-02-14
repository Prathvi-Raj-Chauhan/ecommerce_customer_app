import 'package:ecommerce_customer/COMPONENTS/themeToggle.dart';
import 'package:ecommerce_customer/SERVICES/getUserInstance.dart';
import 'package:ecommerce_customer/SERVICES/logout.dart';
import 'package:ecommerce_customer/SERVICES/logoutweb.dart';
import 'package:ecommerce_customer/theme/themeProvider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [const SizedBox(height: 20), headerSection(), options()],
        ),
      ),
    );
  }

  Widget headerSection() {
    String? userName = context.watch<User>().user?.name;
    String? email = context.watch<User>().user?.email;
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        height: 250,
        child: Column(
          children: [
            Text(
              'Profile',
              style: GoogleFonts.nunito(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, size: 50),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              userName == null ? "Please Login !" : userName,
              style: GoogleFonts.nunito(fontSize: 18),
            ),
            Text(
              email == null ? "usermail@email" : email,
              style: GoogleFonts.nunito(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        color: isLogout ? Colors.red : Theme.of(context).colorScheme.onSurface,
      ),
      title: Text(
        title,
        style: GoogleFonts.nunito(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: isLogout
              ? Colors.red
              : Theme.of(context).colorScheme.onSurface,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  Widget _divider() {
    return Divider(height: 1, thickness: 0.6, color: Colors.grey.shade300);
  }

  Widget options() {
    String? userName = context.watch<User>().user?.name;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _profileTile(
            icon: Icons.settings_rounded,
            title: "Account",
            onTap: () {
              context.push('/account');
            },
          ),
          _divider(),
          ListTile(
            onTap: () {
              context.push('/orders');
            },
            leading: Icon(
              Icons.shopping_cart_checkout_rounded,
              color: Colors.blueAccent,
            ),
            title: Text(
              'Your Orders',
              style: GoogleFonts.nunito(
                color: Colors.blueAccent,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey.shade400,
            ),
          ),
          _divider(),
          _profileTile(
            icon: Icons.location_on_outlined,
            title: "Manage Addresses",
            onTap: () {
              context.push('/addresses');
            },
          ),

          _divider(),
          if (userName != null)
            _profileTile(
              icon: Icons.logout,
              title: "Logout",
              isLogout: true,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Log Out'),
                      content: const Text('Are you sure You want to logout ?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('No'),
                        ),
                        TextButton(
                          onPressed: () {
                            if (kIsWeb) {
                              logoutweb(context);
                            } else {
                              logout(context);
                            }
                            Navigator.pop(context);
                          },
                          child: const Text('Yes'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          const SizedBox(height: 16),

          // Theme Settings Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Appearance',
                  style: GoogleFonts.nunito(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                Consumer<ThemeProvider>(
                  builder: (context, themeProvider, child) {
                    return CompactThemeToggle(
                      isDarkMode: themeProvider.isDarkMode,
                      onToggle: (value) {
                        themeProvider.setTheme(value);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
