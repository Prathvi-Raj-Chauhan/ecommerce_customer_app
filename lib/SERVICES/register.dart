import 'package:ecommerce_customer/FireBase%20Services/notification_service.dart';
import 'package:ecommerce_customer/SERVICES/dioclient.dart';
import 'package:ecommerce_customer/SERVICES/flutterSecureStorage.dart';
import 'package:flutter/foundation.dart';

Future<bool> register(
  String name,
  String email,
  String password,
  String confirmPassword,
) async {
  if (password != confirmPassword) {
    print('PASSWORDS DIDNT MATCH');
    return false;
  }
  try {
    var body = {"name": name, "email": email, "password": password};
    final res = await Dioclient.dio.post('/register', data: body);
    if (res.statusCode == 200 || res.statusCode == 201 || res.statusCode == 204) {
      if(!kIsWeb){
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
    } else {
      print('COULDNT register');
      return false;
    }
  } catch (e) {
    print('COUGHT IN CATCH - ${e}');
    return false;
  }
}
