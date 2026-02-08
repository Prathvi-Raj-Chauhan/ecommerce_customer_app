import 'package:ecommerce_customer/SERVICES/dioclient.dart';
import 'package:ecommerce_customer/SERVICES/flutterSecureStorage.dart';
import 'package:ecommerce_customer/SERVICES/getUserInstance.dart';
import 'package:ecommerce_customer/SERVICES/setUser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';

Future<void> logout(BuildContext context) async {
  try {
    SecureStorage.instance.clearTokens();
    context.go('/');
    User().clearUser();

  } catch (e) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Logout failed')));
  }
}
