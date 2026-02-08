import 'package:ecommerce_customer/MODELS/userInstance.dart';
import 'package:ecommerce_customer/SERVICES/dioclient.dart';
import 'package:ecommerce_customer/SERVICES/getUserInstance.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> setUser() async {
  try {
    print('Invoked setUser()');
    var res = await Dioclient.dio.get(
      '/auth-check',
    ); 
    if (res.data['status'] == true) {
      final pref = await SharedPreferences.getInstance();
      final username = "username";
      final email = "email";
      print('API USER NAME => ${res.data['userName']}');
      pref.setString(username, res.data['userName']);
      pref.setString(email, res.data['email']);
      await User().setUserInstance();
    } else {
      print('Success was false');
    }
  } catch (er) {
    print("got in catch in main while setting user details ${er}");
  }
}
