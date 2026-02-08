import 'package:ecommerce_customer/FireBase%20Services/notification_service.dart';
import 'package:ecommerce_customer/SERVICES/dioclient.dart';
import 'package:ecommerce_customer/SERVICES/flutterSecureStorage.dart';
import 'package:ecommerce_customer/SERVICES/setUser.dart';
import 'package:flutter/foundation.dart';

Future<bool> login(String email, String password) async {
  try {
    final body = {"email": email, "password": password};
    final res = await Dioclient.dio.post('/login', data: body);

    if (res.statusCode == 200 ||
        res.statusCode == 201 ||
        res.statusCode == 204) {
      if (!kIsWeb) {
        await SecureStorage.instance.saveTokens(accessToken: res.data['token']);
        try {
          final deviceToken = await NotificationService().getDeviceToken();
          print(deviceToken);
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
      await setUser();

      return true;
    }
    return false;
  } catch (e) {
    print('LOGIN ERROR: $e');
    return false;
  }
}
