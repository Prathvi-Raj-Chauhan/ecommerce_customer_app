import 'package:ecommerce_customer/MODELS/userInstance.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User extends ChangeNotifier {
  // Singleton pattern
  static final User _instance = User._internal();
  factory User() => _instance;
  User._internal();

  Userinstance? user;

  Future<void> setUserInstance() async {
    final prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString("username");
    String? email = prefs.getString("email");
    print("Setting user's UserNAme => ${name}");
    user = Userinstance(email: email, name: name);
    notifyListeners(); // ✅ Notify widgets to rebuild
  }

  void clearUser() async {
    user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("userName");
    await prefs.remove("email");
    notifyListeners(); // ✅ Notify widgets to rebuild
  }
}
