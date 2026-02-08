import 'package:ecommerce_customer/SERVICES/login.dart';
import 'package:ecommerce_customer/SERVICES/register.dart';
import 'package:ecommerce_customer/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthDialog extends StatefulWidget {
  bool wantsLogin;
  BuildContext context;
  AuthDialog({required this.context, required this.wantsLogin, super.key});

  @override
  State<AuthDialog> createState() => _AuthDialogState();
}

class _AuthDialogState extends State<AuthDialog> {
  TextEditingController _emailcontroller = new TextEditingController();
  TextEditingController _namecontroller = new TextEditingController();
  TextEditingController _passwordcontroller = new TextEditingController();
  TextEditingController _cnfpasswordcontroller = new TextEditingController();
  late bool wantsLogin;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    wantsLogin = widget.wantsLogin;
  }

  @override
  void dispose() {
    _emailcontroller.dispose();
    _namecontroller.dispose();
    _passwordcontroller.dispose();
    _cnfpasswordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 400,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                /// Title
                Text(
                  wantsLogin ? 'Login' : 'Register',
                  style: GoogleFonts.nunito(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 25),

                if (!wantsLogin)
                  TextField(
                    controller: _namecontroller,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                if (!wantsLogin) const SizedBox(height: 12),

                /// Email
                TextField(
                  controller: _emailcontroller,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                /// Password
                TextField(
                  controller: _passwordcontroller,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                if (!wantsLogin)
                  TextField(
                    controller: _cnfpasswordcontroller,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                const SizedBox(height: 50),

                /// Submit Button
                SizedBox(
                  width: 220,
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                            setState(() => isLoading = true);

                            bool success;
                            if (wantsLogin) {
                              success = await login(
                                _emailcontroller.text,
                                _passwordcontroller.text,
                              );
                            } else {
                              success = await register(
                                _namecontroller.text,
                                _emailcontroller.text,
                                _passwordcontroller.text,
                                _cnfpasswordcontroller.text,
                              );
                            }

                            if (!mounted) return;

                            setState(() => isLoading = false);

                            if (success) {
                              Navigator.of(context).pop(true); // ✅ close dialog
                            }
                          },
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(wantsLogin ? "Login" : "Register"),
                  ),
                ),

                const SizedBox(height: 12),

                /// Switch Login/Register
                TextButton(
                  onPressed: () {
                    setState(() {
                      wantsLogin = !wantsLogin;
                    });
                  },
                  child: Text(
                    wantsLogin
                        ? "Don't have an account? Register"
                        : "Already have an account? Login",
                    style: GoogleFonts.nunito(),
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
