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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      child: Container(
        width: 420,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          
        ),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Icon and Title
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    wantsLogin ? Icons.login_rounded : Icons.person_add_rounded,
                    size: 40,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  wantsLogin ? 'Welcome Back' : 'Create Account',
                  style: GoogleFonts.nunito(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  wantsLogin
                      ? 'Sign in to continue shopping'
                      : 'Sign up to get started',
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 32),

                /// Name Field
                if (!wantsLogin)
                  TextField(
                    controller: _namecontroller,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.person_outline, size: 22),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.onSurface),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.onSurface),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                if (!wantsLogin) const SizedBox(height: 16),

                /// Email Field
                TextField(
                  controller: _emailcontroller,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined, size: 22),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Theme.of(context).colorScheme.onSurface),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Theme.of(context).colorScheme.onSurface),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// Password Field
                TextField(
                  controller: _passwordcontroller,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline, size: 22),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Theme.of(context).colorScheme.onSurface),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Theme.of(context).colorScheme.onSurface),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// Confirm Password Field
                if (!wantsLogin)
                  TextField(
                    controller: _cnfpasswordcontroller,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      prefixIcon: Icon(Icons.lock_outline, size: 22),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.onSurface),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.onSurface),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 32),

                /// Submit Button
                /// Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                            // Validate email
                            final isValidEmail = RegExp(
                              r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                            ).hasMatch(_emailcontroller.text.trim());

                            if (!isValidEmail) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Invalid Email'),
                                  content: const Text(
                                    'Please enter a valid email address.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                              return; // Stop here
                            }

                            // Validate password match (for registration)
                            if (!wantsLogin &&
                                _passwordcontroller.text !=
                                    _cnfpasswordcontroller.text) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Password Mismatch'),
                                  content: const Text(
                                    'Passwords do not match. Please try again.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                              return; // IMPORTANT: Stop execution here
                            }

                            // Validate required fields
                            if (!wantsLogin &&
                                _namecontroller.text.trim().isEmpty) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Name Required'),
                                  content: const Text(
                                    'Please enter your full name.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                              return;
                            }

                            if (_passwordcontroller.text.isEmpty) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Password Required'),
                                  content: const Text(
                                    'Please enter a password.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                              return;
                            }

                            // All validations passed, proceed
                            setState(() => isLoading = true);

                            bool success;
                            if (wantsLogin) {
                              success = await login(
                                _emailcontroller.text.trim(),
                                _passwordcontroller.text,
                              );
                              if(!success){
                                showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Wrong Credentials '),
                                  content: const Text(
                                    'Please enter correct credentials',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                              }
                            } else {
                              success = await register(
                                _namecontroller.text.trim(),
                                _emailcontroller.text.trim(),
                                _passwordcontroller.text,
                                _cnfpasswordcontroller.text,
                                context
                              );
                              if(!success){
                                showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Server Error'),
                                  content: const Text(
                                    'Please try again after some time !',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                              }
                            }

                            if (!mounted) return;

                            setState(() => isLoading = false);

                            if (success) {
                              Navigator.of(context).pop(true);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            wantsLogin ? "Sign In" : "Create Account",
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 20),

                /// Divider
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'or',
                        style: GoogleFonts.nunito(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                  ],
                ),

                const SizedBox(height: 16),

                /// Switch Login/Register
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      wantsLogin
                          ? "Don't have an account?"
                          : "Already have an account?",
                      style: GoogleFonts.nunito(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          wantsLogin = !wantsLogin;
                        });
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                      child: Text(
                        wantsLogin ? "Sign Up" : "Sign In",
                        style: GoogleFonts.nunito(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
