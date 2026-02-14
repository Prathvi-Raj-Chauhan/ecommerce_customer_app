import 'package:ecommerce_customer/FireBase%20Services/notification_service.dart';
import 'package:ecommerce_customer/SERVICES/dioclient.dart';
import 'package:ecommerce_customer/SERVICES/flutterSecureStorage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future<bool> register(
  String name,
  String email,
  String password,
  String confirmPassword,
  BuildContext context,
) async {
  if (password != confirmPassword) {
    print('PASSWORDS DIDNT MATCH');
    return false;
  }
  try {
    var body = {"name": name, "email": email, "password": password};
    final res = await Dioclient.dio.post('/register', data: body);
    
    if (res.statusCode == 200 ||
        res.statusCode == 201 ||
        res.statusCode == 204) {
      // Registration successful
      if (!kIsWeb) {
        SecureStorage.instance.saveTokens(accessToken: res.data['token']);
        try {
          final deviceToken = NotificationService().getDeviceToken();
          var body = {"fcm": deviceToken};
          final res = await Dioclient.dio.post("/setFcm", data: body);
          if (res.statusCode == 200) {
            print("FCM SET SUCCESSFULL ✅");
          } else {
            print("❌ ERROR IN SETTING FCM");
          }
        } catch (err) {
          print("❌ Got in catch while setting FCM Error = ${err}");
        }
      }
      return true;
    } else if (res.statusCode == 400) {
      // Email already registered
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Email already registered'),
          content: const Text(
            'This email is already registered, please create a new account or use login',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return false;
    } else {
      print('COULDNT register - Status: ${res.statusCode}');
      return false;
    }
  } catch (e) {
    print('CAUGHT IN CATCH - ${e}');
    return false;
  }
}
