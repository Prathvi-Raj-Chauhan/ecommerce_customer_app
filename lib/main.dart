import 'package:ecommerce_customer/FireBase%20Services/notification_service.dart';
import 'package:ecommerce_customer/PROVIDER/CartProvider.dart';
import 'package:ecommerce_customer/PROVIDER/HomeProductsProvider.dart';
import 'package:ecommerce_customer/PROVIDER/NotificationProvider.dart';
import 'package:ecommerce_customer/ROUTER/router.dart';
import 'package:ecommerce_customer/SCREEN/HomeScreen.dart';
import 'package:ecommerce_customer/SERVICES/dioclient.dart';
import 'package:ecommerce_customer/SERVICES/getUserInstance.dart';
import 'package:ecommerce_customer/SERVICES/setUser.dart';
import 'package:ecommerce_customer/firebase_options.dart';
import 'package:ecommerce_customer/theme/theme.dart';
import 'package:ecommerce_customer/theme/themeProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await FirebaseMessaging.instance.setAutoInitEnabled(true);
  }
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

@pragma(
  'vm:entry-point',
) // this makes the below function entry point in background
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print(message.notification!.title.toString());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!kIsWeb) {
      Future.microtask(() {
        NotificationService.setNotificationProvider(
          context.read<NotificationProvider>(),
        );
      });
      NotificationService().requestNotificationPermission();
      NotificationService().firebaseInit(context);
      NotificationService().setupInteractMessage(context);
      NotificationService().isTokenRefresh();
    }
    Dioclient.init();
    Future.microtask(() => setUser());
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider.value(value: User()),
        ChangeNotifierProvider(create: (_) => HomeProductsProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'E-Commerce',
            theme: CustomerTheme.lightTheme,
            darkTheme: CustomerTheme.darkTheme,
            themeMode: themeProvider.isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,
            routerConfig: router,
          );
        },
      ),
    );
  }
}
