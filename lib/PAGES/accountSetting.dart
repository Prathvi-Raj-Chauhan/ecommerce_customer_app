import 'package:ecommerce_customer/COMPONENTS/AuthDialog.dart';
import 'package:ecommerce_customer/PAGES/resetPassword.dart';
import 'package:ecommerce_customer/SERVICES/dioclient.dart';
import 'package:ecommerce_customer/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class ACcountSetting extends StatefulWidget {
  const ACcountSetting({super.key});

  @override
  State<ACcountSetting> createState() => _ACcountSettingState();
}

class _ACcountSettingState extends State<ACcountSetting> {
    bool? isLoggedin; // Changed to nullable

  @override
  void initState() {
    super.initState();
    checkAuthAndSetState();
  }

  Future<void> checkAuthAndSetState() async {
    try {
      var res = await Dioclient.dio.get('/auth-check');
      setState(() {
        if (res.statusCode == 401) {
          isLoggedin = false;
        } else {
          isLoggedin = res.data['status'] == true;
        }
      });
    } catch (e) {
      setState(() {
        isLoggedin = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      
      child:  isLoggedin == null
          ? const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            )
          : !isLoggedin!
              ? pleaseLogin()
              : Scaffold(
        body: Scaffold(
          appBar: AppBar(
          title: Text(
            'Account Settings',
            style: GoogleFonts.nunito(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Theme.of(context).colorScheme.onSurface
            ),
          ),
          centerTitle: true,
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          actionsIconTheme: IconThemeData(color: Theme.of(context).colorScheme.onSurface),
        ),
          body: Column(
            children: [
              // In your account page, add this button/option:
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.lock_reset, color: Colors.orange.shade700),
                ),
                title: Text(
                  'Reset Password',
                  style: GoogleFonts.nunito(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  'Change your account password',
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  context.push('/reset-pass');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
    Widget pleaseLogin() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min, // 👈 important
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: Container(child: Text('Please Login First'))),
          loginButton(),
        ],
      ),
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
        context.go('/');
      },
      child: Text(
        'Login Now !',
        style: GoogleFonts.nunito(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(backgroundColor: CustomerTheme.accent),
    );
  }

}
